enum PrayerName { fajr, dhuhr, asr, maghrib, isha }

class PrayerTime {
  final int id;
  final PrayerName prayerName;
  final DateTime utcTime;
  final String localTimezone;
  final DateTime date;

  PrayerTime({
    required this.id,
    required this.prayerName,
    required this.utcTime,
    required this.localTimezone,
    required this.date,
  }) : assert(utcTime.isUtc, 'utcTime must be in UTC');

  int get prayerIndex {
    switch (prayerName) {
      case PrayerName.fajr: return 1;
      case PrayerName.dhuhr: return 2;
      case PrayerName.asr: return 3;
      case PrayerName.maghrib: return 4;
      case PrayerName.isha: return 5;
    }
  }
}
