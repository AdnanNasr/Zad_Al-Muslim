import 'package:isar_community/isar.dart';
import '../../domain/entities/prayer_time.dart';

part 'prayer_time_entity.g.dart';

@Collection()
class PrayerTimeEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late int deterministicId; // YYYYMMDDN

  @enumerated
  late PrayerName prayerName;

  late DateTime time;
  late String localTimezone;
  late DateTime date;

  PrayerTimeEntity();

  // Mapping from Domain to Infrastructure
  factory PrayerTimeEntity.fromDomain(PrayerTime prayer) {
    return PrayerTimeEntity()
      ..deterministicId = prayer.id
      ..prayerName = prayer.prayerName
      ..time = prayer.time
      ..localTimezone = prayer.localTimezone
      ..date = prayer.date;
  }

  // Mapping from Infrastructure to Domain
  PrayerTime toDomain() {
    return PrayerTime(
      id: deterministicId,
      prayerName: prayerName,
      time: time,
      localTimezone: localTimezone,
      date: date,
    );
  }
}
