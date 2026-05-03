import 'dart:math' as math;

import 'package:adhan/adhan.dart';
import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/qebla/domain/entities/qibla_entity.dart';
import 'package:zad_al_muslim/features/qebla/domain/repositories/qibla_repository.dart';

/// تنفيذ مستودع القبلة باستخدام مكتبة adhan الموجودة بالفعل
class QiblaRepositoryImpl implements QiblaRepository {
  /// إحداثيات الكعبة المشرفة (مكة المكرمة)
  static const double _kaabaLat = 21.4225;
  static const double _kaabaLng = 39.8262;

  @override
  Either<Failure, QiblaEntity> getQiblaDirection({
    required double latitude,
    required double longitude,
  }) {
    try {
      final coordinates = Coordinates(latitude, longitude);

      // adhan.Qibla تحسب الزاوية من الشمال الحقيقي (True North)
      final qibla = Qibla(coordinates);
      final qiblaAngle = qibla.direction;

      // حساب المسافة إلى الكعبة بالكيلومترات (معادلة Haversine)
      final distanceKm = _haversineDistance(
        latitude,
        longitude,
        _kaabaLat,
        _kaabaLng,
      );

      return Right(QiblaEntity(qiblaAngle: qiblaAngle, distanceKm: distanceKm));
    } catch (e) {
      return Left(LocationFailure('تعذّر حساب اتجاه القبلة: ${e.toString()}'));
    }
  }

  /// معادلة Haversine — تُرجع المسافة بالكيلومترات
  double _haversineDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusKm = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _toRad(double deg) => deg * math.pi / 180.0;
}
