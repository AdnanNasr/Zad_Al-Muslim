import 'package:isar_community/isar.dart';

part 'dhikr_state_model.g.dart';

@collection
class DhikrStateModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String dhikrId; // e.g. "أذكار الصباح_1"

  late int remainingCount;

  late DateTime date; // The date when this state was last updated
}
