import "package:qcf_quran/qcf_quran.dart" as qcf;

abstract class SurahNameByPageNumberDataRepo {
  Map<String, int> getSurahNameByPageNumberData(int pageNumber);
}

class SurahNameByPageNumberDataImpl implements SurahNameByPageNumberDataRepo {
  @override
  Map<String, int> getSurahNameByPageNumberData(int pageNumber) {
    final pageData = qcf.getPageData(pageNumber)[0];
    final surahNumber = pageData["surah"] as int;
    final start = pageData["start"] as int;

    final finalPageData = {"surah": surahNumber, "start": start};
    return finalPageData;
  }
}
