import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/qebla/domain/entities/qibla_entity.dart';

abstract class QiblaRepository {
  /// يحسب اتجاه القبلة والمسافة إلى الكعبة من إحداثيات المستخدم
  Either<Failure, QiblaEntity> getQiblaDirection({
    required double latitude,
    required double longitude,
  });
}
