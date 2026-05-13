import 'package:adhan/adhan.dart';
import '../entities/location.dart';
import '../entities/prayer_time.dart';
import '../repositories/i_prayer_repository.dart';
import 'schedule_notifications_usecase.dart';

class RecalculateAndScheduleUseCase {
  final IPrayerRepository _prayerRepository;
  final ScheduleNotificationsUseCase _scheduleNotifications;

  RecalculateAndScheduleUseCase(
    this._prayerRepository,
    this._scheduleNotifications,
  );

  Future<void> call(Location location) async {
    // Optimization: Check if location has changed significantly
    final lastLoc = await _prayerRepository.getLastKnownLocation();
    bool locationChanged = true;
    
    if (lastLoc != null) {
      final double latDiff = (lastLoc['lat']! - location.latitude).abs();
      final double lngDiff = (lastLoc['lng']! - location.longitude).abs();
      // If difference is very small (approx 100m), consider it the same location
      if (latDiff < 0.001 && lngDiff < 0.001) {
        locationChanged = false;
      }
    }

    if (!locationChanged) {
      // Location didn't change, just try to refresh the 7-day schedule if needed
      await _scheduleNotifications(force: false);
      return;
    }

    // Location changed, perform full recalculation for 30 days
    final coordinates = Coordinates(location.latitude, location.longitude);
    final params = CalculationMethod.umm_al_qura.getParameters(); 
    
    final now = DateTime.now().toUtc();
    final prayersToSave = <PrayerTime>[];

    for (int i = 0; i < 30; i++) {
      final date = now.add(Duration(days: i));
      final dateComponents = DateComponents(date.year, date.month, date.day);
      final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

      void addPrayer(PrayerName name, DateTime time) {
         prayersToSave.add(PrayerTime(
            id: int.parse('${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}${_getPrayerIndex(name)}'),
            prayerName: name,
            utcTime: time.toUtc(),
            localTimezone: location.timezone,
            date: DateTime.utc(date.year, date.month, date.day),
         ));
      }

      addPrayer(PrayerName.fajr, prayerTimes.fajr);
      addPrayer(PrayerName.sunrise, prayerTimes.sunrise);
      addPrayer(PrayerName.dhuhr, prayerTimes.dhuhr);
      addPrayer(PrayerName.asr, prayerTimes.asr);
      addPrayer(PrayerName.maghrib, prayerTimes.maghrib);
      addPrayer(PrayerName.isha, prayerTimes.isha);
    }

    await _prayerRepository.deleteAll();
    await _prayerRepository.savePrayers(prayersToSave);
    
    // Save the new location
    await _prayerRepository.saveLastKnownLocation(location.latitude, location.longitude);
    
    // Force reschedule since data has changed
    await _scheduleNotifications(force: true);
  }

  int _getPrayerIndex(PrayerName name) {
    switch (name) {
      case PrayerName.fajr: return 1;
      case PrayerName.sunrise: return 2;
      case PrayerName.dhuhr: return 3;
      case PrayerName.asr: return 4;
      case PrayerName.maghrib: return 5;
      case PrayerName.isha: return 6;
    }
  }
}
