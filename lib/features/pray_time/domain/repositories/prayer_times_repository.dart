import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prayer_times_entity.dart';

abstract class PrayerTimesRepository {
  Future<Either<Failure, PrayerTimesEntity>> getTodayPrayerTimes(Position position);
}
