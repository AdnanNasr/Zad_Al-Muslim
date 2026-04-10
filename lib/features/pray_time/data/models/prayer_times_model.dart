import 'package:isar/isar.dart';
import '../../domain/entities/prayer_times_entity.dart';

part 'prayer_times_model.g.dart';

@collection
class PrayerTimesModel {
  PrayerTimesModel();
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime date; // اليوم الذي تخصه هذه الأوقات (تاريخ محلي فقط)

  // نخزّن الأوقات كدقائق من منتصف الليل المحلي (0–1439)
  // هذا النهج مستقل تماماً عن UTC وتحويلات المناطق الزمنية في Isar
  late int fajrMinutes;
  late int sunriseMinutes;
  late int dhuhrMinutes;
  late int asrMinutes;
  late int maghribMinutes;
  late int ishaMinutes;

  @ignore
  DateTime get fajr => _minutesToLocal(date, fajrMinutes);
  @ignore
  DateTime get sunrise => _minutesToLocal(date, sunriseMinutes);
  @ignore
  DateTime get dhuhr => _minutesToLocal(date, dhuhrMinutes);
  @ignore
  DateTime get asr => _minutesToLocal(date, asrMinutes);
  @ignore
  DateTime get maghrib => _minutesToLocal(date, maghribMinutes);
  @ignore
  DateTime get isha => _minutesToLocal(date, ishaMinutes);

  /// تحويل الدقائق إلى DateTime محلي لليوم المحدد
  static DateTime _minutesToLocal(DateTime date, int minutes) {
    return DateTime(date.year, date.month, date.day,
        minutes ~/ 60, minutes % 60);
  }

  /// تحويل DateTime محلي إلى دقائق من منتصف الليل
  static int _localToMinutes(DateTime dt) => dt.hour * 60 + dt.minute;

  PrayerTimesEntity toEntity() {
    return PrayerTimesEntity(
      date: date,
      fajr: _minutesToLocal(date, fajrMinutes),
      sunrise: _minutesToLocal(date, sunriseMinutes),
      dhuhr: _minutesToLocal(date, dhuhrMinutes),
      asr: _minutesToLocal(date, asrMinutes),
      maghrib: _minutesToLocal(date, maghribMinutes),
      isha: _minutesToLocal(date, ishaMinutes),
    );
  }

  factory PrayerTimesModel.fromEntity(PrayerTimesEntity entity) {
    return PrayerTimesModel()
      ..date = entity.date
      ..fajrMinutes = _localToMinutes(entity.fajr)
      ..sunriseMinutes = _localToMinutes(entity.sunrise)
      ..dhuhrMinutes = _localToMinutes(entity.dhuhr)
      ..asrMinutes = _localToMinutes(entity.asr)
      ..maghribMinutes = _localToMinutes(entity.maghrib)
      ..ishaMinutes = _localToMinutes(entity.isha);
  }
}