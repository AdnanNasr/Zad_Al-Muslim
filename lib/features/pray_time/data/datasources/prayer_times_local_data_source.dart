import 'package:adhan/adhan.dart';
import 'package:isar/isar.dart';
import '../../../../core/database/isar_db.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/core/utils/location/location_locator.dart';
import '../models/prayer_times_model.dart';


abstract class PrayerTimesLocalDataSource {
  Future<PrayerTimesModel?> getLastPrayerTimes(DateTime date);
  Future<void> cachePrayerTimes(PrayerTimesModel prayerTimes);
  Future<CalculationParameters> getCalculationParameters(double lat, double lng);
}

class PrayerTimesLocalDataSourceImpl implements PrayerTimesLocalDataSource {
  final Isar? isar = IsarDb.database;

  @override
  Future<PrayerTimesModel?> getLastPrayerTimes(DateTime date) async {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return await isar?.prayerTimesModels
        .filter()
        .dateEqualTo(dateOnly)
        .findFirst();
  }

  @override
  Future<void> cachePrayerTimes(PrayerTimesModel prayerTimes) async {
    await isar?.writeTxn(() async {
      await isar?.prayerTimesModels.put(prayerTimes);
    });
  }

  @override
  Future<CalculationParameters> getCalculationParameters(double lat, double lng) async {
    final locationLocator = sl<LocationLocator>();
    return await locationLocator.getCalculationParameters(lat, lng);
  }

}
