import 'package:isar/isar.dart';

part 'prayer_times_model.g.dart';

@collection
class PrayerTimesModel {
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
}