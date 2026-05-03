import 'package:zad_al_muslim/features/quran/data/datasources/surah_name_by_page_number_data.dart';
import 'package:zad_al_muslim/features/quran/domain/repositories/surah_name_by_page_number_repo.dart';

class SurahNameByPageNumberImpl implements SurahNameByPageNumberRepo {
  SurahNameByPageNumberDataRepo surahNameByPageNumberDataRepo;
  SurahNameByPageNumberImpl(this.surahNameByPageNumberDataRepo);
  @override
  Map<String, int> getSurahNameByPageNumber(int pageNumber) {
    return surahNameByPageNumberDataRepo.getSurahNameByPageNumberData(
      pageNumber,
    );
  }
}
