import 'package:adhan/adhan.dart';
import 'package:isar/isar.dart';
import '../../../../core/database/isar_db.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/utils/location/location_locator.dart';
import '../models/prayer_times_model.dart';
import '../models/prayer_adjustments_model.dart';

abstract class PrayerTimesLocalDataSource {
  Future<PrayerTimesModel?> getLastPrayerTimes(DateTime date);
  Future<void> cachePrayerTimes(PrayerTimesModel prayerTimes);
  Future<CalculationParameters> getCalculationParameters(
    double lat,
    double lng,
  );
  // التعديلات (Adjustments)
  Future<PrayerAdjustmentsModel> getAdjustments();
  Future<void> saveAdjustments(PrayerAdjustmentsModel adjustments);
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
  Future<CalculationParameters> getCalculationParameters(
    double lat,
    double lng,
  ) async {
    final locationLocator = sl<LocationLocator>();
    return await locationLocator.getCalculationParameters(lat, lng);
  }

  @override
  Future<PrayerAdjustmentsModel> getAdjustments() async {
    final existing = await isar?.prayerAdjustmentsModels.get(1);
    return existing ?? PrayerAdjustmentsModel();
  }

  @override
  Future<void> saveAdjustments(PrayerAdjustmentsModel adjustments) async {
    await isar?.writeTxn(() async {
      await isar?.prayerAdjustmentsModels.put(adjustments);
    });
  }
}
