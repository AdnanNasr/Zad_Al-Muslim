import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prayer_times_entity.dart';
import '../repositories/prayer_times_repository.dart';

class GetPrayerTimesUseCase {
  final PrayerTimesRepository repository;

  GetPrayerTimesUseCase(this.repository);

  Future<Either<Failure, PrayerTimesEntity>> call(Position position) async {
    return await repository.getTodayPrayerTimes(position);
  }
}
