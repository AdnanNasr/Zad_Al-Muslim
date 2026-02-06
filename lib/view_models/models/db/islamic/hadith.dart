import 'package:isar/isar.dart';
import 'package:noor_quran/constants/enums/my_enums.dart';

part 'hadith.g.dart';

@collection
class Hadith {
  Id id = Isar.autoIncrement;

  late String hadith;
  late String hadithNarrator;
  late bool isFeautred;
  late String topic;
  
  @enumerated
  late HadithGrade grade;

  late String book;
}

