import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/prayer_times_entity.dart';
import '../../domain/repositories/prayer_times_repository.dart';
import '../datasources/prayer_times_local_data_source.dart';
import '../models/prayer_times_model.dart';
import '../models/prayer_adjustments_model.dart';
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart' as tzmap;
import 'package:timezone/timezone.dart' as tz_core;
import '../../domain/repositories/prayer_notification_service.dart';

class PrayerTimesRepositoryImpl implements PrayerTimesRepository {
  final PrayerTimesLocalDataSource localDataSource;
  final IPrayerNotificationService notificationService;

  PrayerTimesRepositoryImpl({
    required this.localDataSource,
    required this.notificationService,
  });

  @override
  Future<Either<Failure, PrayerTimesEntity>> getPrayerTimesForDate(
    Position position,
    DateTime date, {
    PrayerAdjustmentsModel? adjustments,
  }) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);

      // محاولة الجلب من الكاش أولاً
      PrayerTimesModel? cachedTimes = await localDataSource.getLastPrayerTimes(
        dateOnly,
      );

      if (cachedTimes == null) {
        // حساب الأوقات إذا لم تكن مخزنة
        final coordinates = Coordinates(position.latitude, position.longitude);
        final settings = await localDataSource.getCalculationParameters(
          position.latitude,
          position.longitude,
        );

        settings.highLatitudeRule = HighLatitudeRule.seventh_of_the_night;

        final tzName = tzmap.latLngToTimezoneString(
          position.latitude,
          position.longitude,
        );
        final location = tz_core.getLocation(tzName);
        final tzDate = tz_core.TZDateTime.from(dateOnly, location);

        final adhanTimes = PrayerTimes(
          coordinates,
          DateComponents(dateOnly.year, dateOnly.month, dateOnly.day),
          settings,
          utcOffset: tzDate.timeZoneOffset,
        );

        cachedTimes = PrayerTimesModel()
          ..date = dateOnly
          ..fajrMinutes = adhanTimes.fajr.hour * 60 + adhanTimes.fajr.minute
          ..sunriseMinutes =
              adhanTimes.sunrise.hour * 60 + adhanTimes.sunrise.minute
          ..dhuhrMinutes = adhanTimes.dhuhr.hour * 60 + adhanTimes.dhuhr.minute
          ..asrMinutes = adhanTimes.asr.hour * 60 + adhanTimes.asr.minute
          ..maghribMinutes =
              adhanTimes.maghrib.hour * 60 + adhanTimes.maghrib.minute
          ..ishaMinutes = adhanTimes.isha.hour * 60 + adhanTimes.isha.minute;

        await localDataSource.cachePrayerTimes(cachedTimes);
      }

      // تطبيق الـ offsets على إنشاء الـ Entity
      final entity = cachedTimes.toEntityWithOffsets(adjustments);

      // إعادة جدولة الإشعارات فقط إذا كان اليوم هو اليوم الحالي
      // Legacy notification logic disabled
      /*
      final now = DateTime.now();
      if (dateOnly.year == now.year &&
          dateOnly.month == now.month &&
          dateOnly.day == now.day) {
        await notificationService.scheduleDailyNotifications(entity);
      }
      */

      return Right(entity);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PrayerAdjustmentsModel>> saveAdjustments(
    PrayerAdjustmentsModel adjustments,
    Position position,
  ) async {
    try {
      await localDataSource.saveAdjustments(adjustments);

      // إعادة جدولة إشعارات اليوم بالأوقات المعدلة الجديدة
      final now = DateTime.now();
      final todayResult = await getPrayerTimesForDate(
        position,
        DateTime(now.year, now.month, now.day),
        adjustments: adjustments,
      );

      /*
      todayResult.fold((failure) => null, (entity) async {
        await notificationService.scheduleDailyNotifications(entity);
      });
      */

      return Right(adjustments);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PrayerAdjustmentsModel>> getAdjustments() async {
    try {
      final adjustments = await localDataSource.getAdjustments();
      return Right(adjustments);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
