import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/qebla/domain/entities/qibla_entity.dart';

abstract class QiblaRepository {
  /// يحسب اتجاه القبلة والمسافة إلى الكعبة من إحداثيات المستخدم
  Either<Failure, QiblaEntity> getQiblaDirection({
    required double latitude,
    required double longitude,
  });
}
