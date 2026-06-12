import 'package:zad_al_muslim/features/quran_moratal/domain/entities/surah_meta_moratal_entity.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/repositories/surah_meta_moratal_repo.dart';

class GetSurahsMoratalNames {
  SurahMetaMoratalRepo surahMetaMoratalRepo;
  GetSurahsMoratalNames(this.surahMetaMoratalRepo);

  List<SurahMetaMoratalEntity> call() {
    return surahMetaMoratalRepo.getSurahsName();
  }
}
