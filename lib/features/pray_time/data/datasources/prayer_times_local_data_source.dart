import 'package:adhan/adhan.dart';
import 'package:isar/isar.dart';
import '../../../../core/database/isar_db.dart';
import '../../../../core/utils/network/network_info.dart';
import '../models/prayer_times_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart';

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
    try {
      final internetConnected = await NetworkInfo.hasValidConnection();
      List<Placemark> placemarks = [];
      if (internetConnected) {
        placemarks = await placemarkFromCoordinates(lat, lng);
      }
      String countryCode = '';
      if (placemarks.isNotEmpty) {
        countryCode = placemarks.first.isoCountryCode?.toUpperCase() ?? '';
      }

      switch (countryCode) {
        case 'SA': return CalculationMethod.umm_al_qura.getParameters();
        case 'EG': 
        case 'SD':
        case 'LY':
        case 'SY':
        case 'JO':
        case 'PS':
        case 'LB':
          return CalculationMethod.egyptian.getParameters();
        case 'AE':
        case 'BH':
        case 'OM':
          return CalculationMethod.dubai.getParameters();
        case 'KW': return CalculationMethod.kuwait.getParameters();
        case 'QA': return CalculationMethod.qatar.getParameters();
        case 'TR': return CalculationMethod.turkey.getParameters();
        case 'PK':
        case 'AF':
        case 'IN':
        case 'BD':
          final params = CalculationMethod.karachi.getParameters();
          params.madhab = Madhab.hanafi;
          return params;
        case 'US':
        case 'CA':
        case 'MX':
          return CalculationMethod.north_america.getParameters();
        case 'SG':
        case 'MY':
        case 'ID':
          return CalculationMethod.singapore.getParameters();
        case 'IR':
        case 'IQ':
          return CalculationMethod.tehran.getParameters();
        case 'RU':
        case 'UA':
          return CalculationMethod.moon_sighting_committee.getParameters();
        case 'MA':
        case 'DZ':
        case 'TN':
          return CalculationParameters(fajrAngle: 19.0, ishaAngle: 17.0);
        default:
          return CalculationMethod.muslim_world_league.getParameters();
      }
    } on PlatformException {
      return CalculationMethod.muslim_world_league.getParameters();
    } catch (e) {
      return CalculationMethod.muslim_world_league.getParameters();
    }
  }
}
