import 'package:isar/isar.dart';

part 'surah.g.dart';

@collection
class Surah {
  Id id = Isar.autoIncrement;

  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;

  final ayahs = IsarLinks<AyahModel>(); // one to many relation

  final EditionModel? edition; // can be null

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    this.edition,
  });
}

@collection
class AyahModel {
  Id id = Isar.autoIncrement;

  final int number;
  final String text;
  @Index()
  final int numberInSurah;

  @Backlink(to: "ayahs")
  final surah = IsarLink<Surah>();

  AyahModel({
    required this.number,
    required this.text,
    required this.numberInSurah,
  });
}

@embedded
class EditionModel {
  String? identifier;
  String? language;
  String? name;
  String? englishName;

  EditionModel({this.identifier, this.language, this.name, this.englishName});
}
