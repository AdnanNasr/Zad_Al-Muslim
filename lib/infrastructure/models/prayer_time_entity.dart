import 'package:isar/isar.dart';
import '../../domain/entities/prayer_time.dart';

part 'prayer_time_entity.g.dart';

@Collection()
class PrayerTimeEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late int deterministicId; // YYYYMMDDN

  @enumerated
  late PrayerName prayerName;

  late DateTime utcTime;
  late String localTimezone;
  late DateTime date;

  PrayerTimeEntity();

  // Mapping from Domain to Infrastructure
  factory PrayerTimeEntity.fromDomain(PrayerTime prayer) {
    return PrayerTimeEntity()
      ..deterministicId = prayer.id
      ..prayerName = prayer.prayerName
      ..utcTime = prayer.utcTime
      ..localTimezone = prayer.localTimezone
      ..date = prayer.date;
  }

  // Mapping from Infrastructure to Domain
  PrayerTime toDomain() {
    return PrayerTime(
      id: deterministicId,
      prayerName: prayerName,
      utcTime: utcTime.toUtc(),
      localTimezone: localTimezone,
      date: date.toUtc(),
    );
  }
}
