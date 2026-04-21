import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prayer_times_entity.dart';
import '../repositories/prayer_times_repository.dart';
import '../../data/models/prayer_adjustments_model.dart';

class GetPrayerTimesUseCase {
  final PrayerTimesRepository repository;

  GetPrayerTimesUseCase(this.repository);

  /// يجلب أوقات الصلاة لتاريخ محدد مع تطبيق تعديلات الدقائق.
  /// [position] — موقع المستخدم الحالي.
  /// [date] — التاريخ المطلوب (يساوي اليوم الحالي بشكل افتراضي).
  /// [adjustments] — تعديلات الدقائق (اختياري).
  Future<Either<Failure, PrayerTimesEntity>> call(
    Position position, {
    DateTime? date,
    PrayerAdjustmentsModel? adjustments,
  }) async {
    return await repository.getPrayerTimesForDate(
      position,
      date ?? DateTime.now(),
      adjustments: adjustments,
    );
  }
}
