import 'package:isar/isar.dart';
import "package:noor_quran/view_models/models/db/islamic/tafsser/ayah.dart";

part 'tafsser_surah.g.dart';

@collection
class TafsserSurah {
  Id id = Isar.autoIncrement;

  late int number;
  late String name;
  late String englishName;
  late String englishNameTranslation;
  late String revelationType;

  @Backlink(to: 'surah')
  final ayahs = IsarLinks<AyahTafsser>();

  // embedded edition, optional
  EditionModel? edition;
}

@embedded
class EditionModel {
  String? identifier;
  String? language;
  String? name;
  String? englishName;
}
