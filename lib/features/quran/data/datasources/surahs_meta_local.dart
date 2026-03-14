import 'package:noor_quran/features/quran/data/models/surah_meta_model.dart';
import 'package:qcf_quran/qcf_quran.dart';

abstract class SurahsMetaLocal {
  List<SurahMetaModel> surahsNames();
}

class SurahsMetaLocalImpl implements SurahsMetaLocal {
  @override
  List<SurahMetaModel> surahsNames() {
    const int numberOfSurahs = 114;
    List<SurahMetaModel> surahsMeta = [];

    for (int i = 1; i <= numberOfSurahs; i++) {
      final pageNumber = getPageNumber(i, 1);
      final String arabicName = getSurahNameArabic(i);
      final String englishName = getSurahName(i);
      final int juzzNumber = getJuzNumber(i, 1);
      final int verseCount = getVerseCount(i);
      if (arabicName.isNotEmpty) {
        surahsMeta.add(SurahMetaModel.fromString(i, pageNumber, arabicName, englishName, juzzNumber, verseCount));
      }
    }

    return surahsMeta;
  }
}
