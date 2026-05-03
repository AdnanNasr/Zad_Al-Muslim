import 'package:zad_al_muslim/features/quran/domain/entities/surah_meta_entity.dart';

class SurahMetaModel extends SurahMetaEntity {
  SurahMetaModel({
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

  factory SurahMetaModel.fromString(int surahNumber, int pageNumber, String name, String englishName, int juzzNumber, int verseCount) {
    return SurahMetaModel(
      surahNumber: surahNumber,
      pageNumber: pageNumber,
      arabicName: name,
      englishName: englishName,
      juzzNumber: juzzNumber,
      verseCount: verseCount,
    );
  }

  factory SurahMetaModel.fromEntity(SurahMetaEntity entity) {
    return SurahMetaModel(
      surahNumber: entity.surahNumber,
      pageNumber: entity.pageNumber,
      arabicName: entity.arabicName,
      englishName: entity.englishName,
      juzzNumber: entity.juzzNumber,
      verseCount: entity.verseCount,
    );
  }

  factory SurahMetaModel.fromJson(Map<String, dynamic> json) {
    return SurahMetaModel(
      surahNumber: json['surahNumber'] ?? 0,
      pageNumber: json['pageNumber'] ?? 0,
      arabicName: json['arabicName'] ?? '',
      englishName: json['englishName'] ?? '',
      juzzNumber: json['juzzNumber'] ?? 0,
      verseCount: json['verseCount'] ?? 0,
    );
  }
}
