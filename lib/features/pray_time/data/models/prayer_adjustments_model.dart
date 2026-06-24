import 'package:isar_community/isar.dart';

part 'prayer_adjustments_model.g.dart';

/// نموذج Isar لتخزين تعديلات الدقائق التي يجريها المستخدم على أوقات الصلاة.
/// يُستخدم دائماً record واحد فقط بـ id = 1.
/// الـ offsets هي دقائق تُضاف أو تُطرح من الوقت المحسوب.
/// الحد الأقصى والأدنى لكل offset هو ± 60 دقيقة.
@collection
class PrayerAdjustmentsModel {
  // id ثابت لضمان record واحد فقط في كل وقت
  Id id = 1;

  int fajrOffset = 0;
  int sunriseOffset = 0;
  int dhuhrOffset = 0;
  int asrOffset = 0;
  int maghribOffset = 0;
  int ishaOffset = 0;

  PrayerAdjustmentsModel();

  /// ضمان أن القيمة دائماً بين -60 و +60 دقيقة
  static int clampOffset(int value) => value.clamp(-60, 60);

  /// التحقق إذا كانت هناك أي تعديلات على الصلوات
  bool get hasAnyAdjustment =>
      fajrOffset != 0 ||
      sunriseOffset != 0 ||
      dhuhrOffset != 0 ||
      asrOffset != 0 ||
      maghribOffset != 0 ||
      ishaOffset != 0;

  /// نسخة من النموذج مع offset محدد لصلاة معينة
  PrayerAdjustmentsModel copyWithOffset(String prayerName, int newOffset) {
    final clamped = clampOffset(newOffset);
    final model = PrayerAdjustmentsModel()
      ..id = id
      ..fajrOffset = fajrOffset
      ..sunriseOffset = sunriseOffset
      ..dhuhrOffset = dhuhrOffset
      ..asrOffset = asrOffset
      ..maghribOffset = maghribOffset
      ..ishaOffset = ishaOffset;

    switch (prayerName) {
      case 'الفجر':
        model.fajrOffset = clamped;
        break;
      case 'الشروق':
        model.sunriseOffset = clamped;
        break;
      case 'الظهر':
        model.dhuhrOffset = clamped;
        break;
      case 'العصر':
        model.asrOffset = clamped;
        break;
      case 'المغرب':
        model.maghribOffset = clamped;
        break;
      case 'العشاء':
        model.ishaOffset = clamped;
        break;
    }
    return model;
  }

  /// الحصول على الـ offset الخاص بصلاة معينة بالاسم
  int getOffset(String prayerName) {
    switch (prayerName) {
      case 'الفجر':
        return fajrOffset;
      case 'الشروق':
        return sunriseOffset;
      case 'الظهر':
        return dhuhrOffset;
      case 'العصر':
        return asrOffset;
      case 'المغرب':
        return maghribOffset;
      case 'العشاء':
        return ishaOffset;
      default:
        return 0;
    }
  }

  int get fajrAdjustment => fajrOffset;
  int get sunriseAdjustment => sunriseOffset;
  int get dhuhrAdjustment => dhuhrOffset;
  int get asrAdjustment => asrOffset;
  int get maghribAdjustment => maghribOffset;
  int get ishaAdjustment => ishaOffset;
}
