import 'package:zad_al_muslim/features/quran/data/datasources/surah_name_by_page_number_data.dart';

class GetSurahNumberByPageNumber {
  SurahNameByPageNumberDataImpl surahNameByPageNumberDataImpl;
  GetSurahNumberByPageNumber(this.surahNameByPageNumberDataImpl);

  Map<String, int> call(int pageNumber) {
    return surahNameByPageNumberDataImpl.getSurahNameByPageNumberData(
      pageNumber,
    );
  }
}
