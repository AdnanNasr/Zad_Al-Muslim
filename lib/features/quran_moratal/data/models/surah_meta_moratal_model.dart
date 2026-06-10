import 'package:zad_al_muslim/features/quran/domain/entities/surah_meta_entity.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/entities/surah_meta_moratal_entity.dart';

class SurahMetaMoratalModel extends SurahMetaMoratalEntity {
  SurahMetaMoratalModel({
    required super.surahNumber,
    required super.pageNumber,
    required super.arabicName,
    required super.englishName,
    required super.juzzNumber,
    required super.verseCount,
  });

  SurahMetaEntity toEntity() {
    return SurahMetaEntity(
      surahNumber: surahNumber,
      pageNumber: pageNumber,
      arabicName: arabicName,
      englishName: englishName,
      juzzNumber: juzzNumber,
      verseCount: verseCount,
    );
  }

  factory SurahMetaMoratalModel.fromString(
    int surahNumber,
    int pageNumber,
    String name,
    String englishName,
    int juzzNumber,
    int verseCount,
  ) {
    return SurahMetaMoratalModel(
      surahNumber: surahNumber,
      pageNumber: pageNumber,
      arabicName: name,
      englishName: englishName,
      juzzNumber: juzzNumber,
      verseCount: verseCount,
    );
  }

  factory SurahMetaMoratalModel.fromEntity(SurahMetaEntity entity) {
    return SurahMetaMoratalModel(
      surahNumber: entity.surahNumber,
      pageNumber: entity.pageNumber,
      arabicName: entity.arabicName,
      englishName: entity.englishName,
      juzzNumber: entity.juzzNumber,
      verseCount: entity.verseCount,
    );
  }

  factory SurahMetaMoratalModel.fromJson(Map<String, dynamic> json) {
    return SurahMetaMoratalModel(
      surahNumber: json['surahNumber'] ?? 0,
      pageNumber: json['pageNumber'] ?? 0,
      arabicName: json['arabicName'] ?? '',
      englishName: json['englishName'] ?? '',
      juzzNumber: json['juzzNumber'] ?? 0,
      verseCount: json['verseCount'] ?? 0,
    );
  }
}
