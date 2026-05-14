enum PrayerName { fajr, sunrise, dhuhr, asr, maghrib, isha }

class PrayerTime {
  final int id;
  final PrayerName prayerName;
  final DateTime time;
  final String localTimezone;
  final DateTime date;

  PrayerTime({
    required this.id,
    required this.prayerName,
    required this.time,
    required this.localTimezone,
    required this.date,
  });

  int get prayerIndex {
    switch (prayerName) {
      case PrayerName.fajr: return 1;
      case PrayerName.sunrise: return 2;
      case PrayerName.dhuhr: return 3;
      case PrayerName.asr: return 4;
      case PrayerName.maghrib: return 5;
      case PrayerName.isha: return 6;
    }
  }
}
