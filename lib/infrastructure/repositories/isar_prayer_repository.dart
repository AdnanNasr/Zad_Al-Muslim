import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/prayer_time.dart';
import '../../domain/repositories/i_prayer_repository.dart';
import '../models/prayer_time_entity.dart';

class IsarPrayerRepository implements IPrayerRepository {
  final Isar isar;
  final SharedPreferences sharedPreferences;

  IsarPrayerRepository({
    required this.isar,
    required this.sharedPreferences,
  });

  static const String _lastLatKey = 'last_prayer_lat';
  static const String _lastLngKey = 'last_prayer_lng';
  static const String _lastScheduleKey = 'last_prayer_schedule_date';

  @override
  Future<void> savePrayers(List<PrayerTime> prayers) async {
    final entities = prayers.map((p) => PrayerTimeEntity.fromDomain(p)).toList();
    await isar.writeTxn(() async {
      await isar.prayerTimeEntitys.putAll(entities);
    });
  }

  @override
  Future<List<PrayerTime>> getPrayersForRange(DateTime from, DateTime to) async {
    final entities = await isar.prayerTimeEntitys
        .filter()
        .utcTimeBetween(from, to)
        .findAll();
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> deleteAll() async {
    await isar.writeTxn(() async {
      await isar.prayerTimeEntitys.clear();
    });
  }

  @override
  Future<void> saveLastKnownLocation(double lat, double lng) async {
    await sharedPreferences.setDouble(_lastLatKey, lat);
    await sharedPreferences.setDouble(_lastLngKey, lng);
  }

  @override
  Future<Map<String, double>?> getLastKnownLocation() async {
    final lat = sharedPreferences.getDouble(_lastLatKey);
    final lng = sharedPreferences.getDouble(_lastLngKey);
    if (lat != null && lng != null) {
      return {'lat': lat, 'lng': lng};
    }
    return null;
  }

  @override
  Future<void> saveLastScheduleDate(DateTime date) async {
    await sharedPreferences.setString(_lastScheduleKey, date.toIso8601String());
  }

  @override
  Future<DateTime?> getLastScheduleDate() async {
    final dateStr = sharedPreferences.getString(_lastScheduleKey);
    if (dateStr != null) {
      return DateTime.tryParse(dateStr);
    }
    return null;
  }
}
