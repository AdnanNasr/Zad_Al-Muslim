import 'package:qcf_quran/qcf_quran.dart';
import 'package:zad_al_muslim/core/constants/surah_names.dart';
import 'package:zad_al_muslim/features/quran_moratal/data/models/surah_meta_moratal_model.dart';

abstract class SurahsMoratalMetaData {
  List<SurahMetaMoratalModel> surahsNames();
}

class SurahsMoratalMetaDataImpl implements SurahsMoratalMetaData {
  @override
  List<SurahMetaMoratalModel> surahsNames() {
    const int numberOfSurahs = 114;
    List<SurahMetaMoratalModel> surahsMeta = [];

    for (int i = 1; i <= numberOfSurahs; i++) {
      final pageNumber = getPageNumber(i, 1);
      final String arabicName = SurahNames.getFormattedName(i);
      final String englishName = getSurahName(i);
      final int juzzNumber = getJuzNumber(i, 1);
      final int verseCount = getVerseCount(i);
      if (arabicName.isNotEmpty) {
        surahsMeta.add(
          SurahMetaMoratalModel.fromString(
            i,
            pageNumber,
            arabicName,
            englishName,
            juzzNumber,
            verseCount,
          ),
        );
      }
    }

    return surahsMeta;
  }
}
