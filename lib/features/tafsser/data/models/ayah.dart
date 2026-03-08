import 'package:isar/isar.dart';
import 'package:noor_quran/features/tafsser/data/models/tafsser_surah.dart';

part 'ayah.g.dart';

@collection
class AyahTafsser {
  Id id = Isar.autoIncrement;

  late int number;
  late String text;
  @Index()
  late int numberInSurah;

  final surah = IsarLink<TafsserSurah>();
}