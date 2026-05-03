import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/qebla/domain/entities/qibla_entity.dart';
import 'package:zad_al_muslim/features/qebla/domain/repositories/qibla_repository.dart';

class GetQiblaDirection {
  final QiblaRepository repository;
  GetQiblaDirection(this.repository);

  Either<Failure, QiblaEntity> call({
    required double latitude,
    required double longitude,
  }) {
    return repository.getQiblaDirection(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
