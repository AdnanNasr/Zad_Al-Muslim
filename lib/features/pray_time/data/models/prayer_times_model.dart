import 'package:isar/isar.dart';
import '../../domain/entities/prayer_times_entity.dart';

part 'prayer_times_model.g.dart';

@collection
class PrayerTimesModel {
  PrayerTimesModel();
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime date; // اليوم الذي تخصه هذه الأوقات

  // تخزين الأوقات كـ DateTime مباشر
  late DateTime fajr;
  late DateTime sunrise;
  late DateTime dhuhr;
  late DateTime asr;
  late DateTime maghrib;
  late DateTime isha;

  PrayerTimesEntity toEntity() {
    return PrayerTimesEntity(
      date: date,
      fajr: fajr,
      sunrise: sunrise,
      dhuhr: dhuhr,
      asr: asr,
      maghrib: maghrib,
      isha: isha,
    );
  }

  factory PrayerTimesModel.fromEntity(PrayerTimesEntity entity) {
    return PrayerTimesModel()
      ..date = entity.date
      ..fajr = entity.fajr
      ..sunrise = entity.sunrise
      ..dhuhr = entity.dhuhr
      ..asr = entity.asr
      ..maghrib = entity.maghrib
      ..isha = entity.isha;
  }
}