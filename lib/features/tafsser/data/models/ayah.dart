import 'package:isar/isar.dart';
import '../../domain/entities/tafsser_entities.dart';
import 'package:zad_al_muslim/features/tafsser/data/models/tafsser_surah.dart';

part 'ayah.g.dart';

@collection
class AyahTafsser {
  Id id = Isar.autoIncrement;

  late int number;
  late String text;
  @Index()
  late int numberInSurah;

  final surah = IsarLink<TafsserSurah>();

  AyahTafsserEntity toEntity() {
    return AyahTafsserEntity(
      number: number,
      text: text,
      numberInSurah: numberInSurah,
      surahName: surah.value?.name ?? '',
      surahNumber: surah.value?.number ?? 0,
    );
  }
}