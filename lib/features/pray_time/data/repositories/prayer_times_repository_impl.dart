import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/prayer_times_entity.dart';
import '../../domain/repositories/prayer_times_repository.dart';
import '../datasources/prayer_times_local_data_source.dart';
import '../models/prayer_times_model.dart';

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
      final adhanTimes = PrayerTimes(
        coordinates,
        DateComponents.from(now),
        settings,
      );

      final newModel = PrayerTimesModel()
        ..date = dateOnly
        ..fajr = adhanTimes.fajr
        ..sunrise = adhanTimes.sunrise
        ..dhuhr = adhanTimes.dhuhr
        ..asr = adhanTimes.asr
        ..maghrib = adhanTimes.maghrib
        ..isha = adhanTimes.isha;

      await localDataSource.cachePrayerTimes(newModel);
      final entity = newModel.toEntity();
      await notificationService.scheduleDailyNotifications(entity);
      return Right(entity);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
