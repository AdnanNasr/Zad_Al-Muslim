import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/prayer_times_entity.dart';
import '../../domain/repositories/prayer_times_repository.dart';
import '../datasources/prayer_times_local_data_source.dart';
import '../models/prayer_times_model.dart';
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
  Future<Either<Failure, PrayerTimesEntity>> getTodayPrayerTimes(Position position) async {
    try {
      final now = DateTime.now();
      final dateOnly = DateTime(now.year, now.month, now.day);

      final cachedTimes = await localDataSource.getLastPrayerTimes(dateOnly);
      if (cachedTimes != null) {
        final entity = cachedTimes.toEntity();
        await notificationService.scheduleDailyNotifications(entity);
        return Right(entity);
      }

      // Calculate if not cached
      final coordinates = Coordinates(position.latitude, position.longitude);
      final settings = await localDataSource.getCalculationParameters(
        position.latitude,
        position.longitude,
      );

      final tzName = tzmap.latLngToTimezoneString(position.latitude, position.longitude);
      final location = tz_core.getLocation(tzName);
      final tzDate = tz_core.TZDateTime.from(now, location);

      final adhanTimes = PrayerTimes(
        coordinates,
        DateComponents.from(now),
        settings,
        utcOffset: tzDate.timeZoneOffset,
      );

      // adhan تُرجع local DateTime مباشرةً — نحفظ الساعة والدقيقة كـ int
      // لتجنب أي مشكلة في تحويل UTC/Local عند القراءة من Isar
      final newModel = PrayerTimesModel()
        ..date = dateOnly
        ..fajrMinutes = adhanTimes.fajr.hour * 60 + adhanTimes.fajr.minute
        ..sunriseMinutes = adhanTimes.sunrise.hour * 60 + adhanTimes.sunrise.minute
        ..dhuhrMinutes = adhanTimes.dhuhr.hour * 60 + adhanTimes.dhuhr.minute
        ..asrMinutes = adhanTimes.asr.hour * 60 + adhanTimes.asr.minute
        ..maghribMinutes = adhanTimes.maghrib.hour * 60 + adhanTimes.maghrib.minute
        ..ishaMinutes = adhanTimes.isha.hour * 60 + adhanTimes.isha.minute;

      await localDataSource.cachePrayerTimes(newModel);
      final entity = newModel.toEntity();
      await notificationService.scheduleDailyNotifications(entity);
      return Right(entity);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
