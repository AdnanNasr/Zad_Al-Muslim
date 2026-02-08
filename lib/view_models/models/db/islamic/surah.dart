import 'package:isar/isar.dart';

part 'surah.g.dart';

@collection
class Surah {
  Id id = Isar.autoIncrement;

  late int number;
  late String name;
  late String englishName;
  late String englishNameTranslation;
  late String revelationType;

  @Backlink(to: 'surah')
  final ayahs = IsarLinks<AyahModel>();

  // embedded edition, optional
  EditionModel? edition;
}

@collection
class AyahModel {
  Id id = Isar.autoIncrement;

  late int number;
  late String text;
  @Index()
  late int numberInSurah;

  final surah = IsarLink<Surah>();
}

@embedded
class EditionModel {
  String? identifier;
  String? language;
  String? name;
  String? englishName;
}
