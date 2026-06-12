import 'package:zad_al_muslim/features/quran_moratal/data/datasources/surahs_moratal_meta_data.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/entities/surah_meta_moratal_entity.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/repositories/surah_meta_moratal_repo.dart';

class SurahMetaMoratalImpl implements SurahMetaMoratalRepo {
  SurahsMoratalMetaData surahsMoratalImpl;
  SurahMetaMoratalImpl(this.surahsMoratalImpl);
  @override
  List<SurahMetaMoratalEntity> getSurahsName() {
    return surahsMoratalImpl.surahsNames();
  }
}
