import 'package:adhan/adhan.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/utils/location/location_locator.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';
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
    // 1. التحقق من تغير الموقع لتجنب إعادة الحساب غير الضرورية
    final lastLoc = await _prayerRepository.getLastKnownLocation();
    bool shouldRecalculate = true;

    if (lastLoc != null) {
      final double latDiff = (lastLoc['lat']! - location.latitude).abs();
      final double lngDiff = (lastLoc['lng']! - location.longitude).abs();
      // إذا كان الفرق أقل من 0.001 (حوالي 100 متر)، نعتبره نفس الموقع
      if (latDiff < 0.001 && lngDiff < 0.001) {
        shouldRecalculate = false;
      }
    }

    if (!shouldRecalculate) {
      // نتحقق أيضاً من وجود بيانات حالية
      final todayPrayers = await _prayerRepository.getPrayersForDay(
        DateTime.now(),
      );
      if (todayPrayers.isEmpty) shouldRecalculate = true;
    }

    if (!shouldRecalculate) {
      await _scheduleNotifications(force: false);
      return;
    }

    // 2. الحساب الفعلي (نحفظ بصيغة UTC دائماً لضمان الدقة العالمية)
    final coordinates = Coordinates(location.latitude, location.longitude);
    final params = await sl.call<LocationLocator>().getCalculationParameters(
      location.latitude,
      location.longitude,
    );
    final now = DateTime.now();
    final prayersToSave = <PrayerTime>[];

    for (int i = 0; i < 30; i++) {
      final date = now.add(Duration(days: i));
      final dateComponents = DateComponents(date.year, date.month, date.day);
      final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

      void addPrayer(PrayerName name, DateTime? time) {
        // TODO: fix prayer times logic
        if (time == null) return;
        final prayerDate = DateTime.utc(date.year, date.month, date.day);
        prayersToSave.add(
          PrayerTime(
            id: int.parse(
              '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}${_getPrayerIndex(name)}',
            ),
            prayerName: name,
            time: time.toUtc(), // نحفظ UTC دائماً
            localTimezone: location.timezone,
            date: prayerDate,
          ),
        );
      }

      addPrayer(PrayerName.fajr, prayerTimes.fajr);
      addPrayer(PrayerName.sunrise, prayerTimes.sunrise);
      addPrayer(PrayerName.dhuhr, prayerTimes.dhuhr);
      addPrayer(PrayerName.asr, prayerTimes.asr);
      addPrayer(PrayerName.maghrib, prayerTimes.maghrib);
      addPrayer(PrayerName.isha, prayerTimes.isha);
    }

    try {
      await _prayerRepository.deleteAll();
      await _prayerRepository.savePrayers(prayersToSave);
      await _prayerRepository.saveLastKnownLocation(
        location.latitude,
        location.longitude,
      );
      await _scheduleNotifications(force: true);
    } catch (e) {
      AppLogger.logger.e("Error saving prayers: $e");
    }
  }

  int _getPrayerIndex(PrayerName name) {
    switch (name) {
      case PrayerName.fajr:
        return 1;
      case PrayerName.sunrise:
        return 2;
      case PrayerName.dhuhr:
        return 3;
      case PrayerName.asr:
        return 4;
      case PrayerName.maghrib:
        return 5;
      case PrayerName.isha:
        return 6;
    }
  }
}
