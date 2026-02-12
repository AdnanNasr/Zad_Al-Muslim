import 'package:isar/isar.dart';

part 'quran_models.g.dart';

@collection
class QuranPage {
  Id id = Isar.autoIncrement;

  late int pageNumber;

  late List<Ayah> ayahs;

  bool saved = false;
}

@embedded
class Ayah {
  late int surahNumber;
  late String surahName;
  late int ayahNumber;
  late String ayaTextEmlaey;

  late String text;
}
