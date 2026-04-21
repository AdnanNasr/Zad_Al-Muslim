import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prayer_times_entity.dart';
import '../../data/models/prayer_adjustments_model.dart';

abstract class PrayerTimesRepository {
  /// يجلب أوقات الصلاة لتاريخ محدد مع تطبيق تعديلات الدقائق عليها.
  /// [date] — التاريخ المطلوب (اليوم الحالي أو أي يوم سابق/قادم).
  /// [adjustments] — تعديلات الدقائق للمستخدم (قد تكون null للأوقات الأصلية).
  Future<Either<Failure, PrayerTimesEntity>> getPrayerTimesForDate(
    Position position,
    DateTime date, {
    PrayerAdjustmentsModel? adjustments,
  });

  /// يحفظ تعديلات الدقائق وأعاد جدولة الإشعارات بناءً عليها.
  Future<Either<Failure, PrayerAdjustmentsModel>> saveAdjustments(
    PrayerAdjustmentsModel adjustments,
    Position position,
  );

  /// يجلب التعديلات المحفوظة حالياً.
  Future<Either<Failure, PrayerAdjustmentsModel>> getAdjustments();
}
