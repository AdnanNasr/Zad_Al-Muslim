import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/entities/surah_meta_moratal_entity.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/repositories/surah_meta_moratal_repo.dart';

class GetSurahsMoratalNames {
  SurahMetaMoratalRepo surahMetaMoratalRepo;
  GetSurahsMoratalNames(this.surahMetaMoratalRepo);

  Future<Either<Failure, List<SurahMetaMoratalEntity>>> call({
    required String qariUri,
  }) async {
    return await surahMetaMoratalRepo.getSurahsName(qariUri: qariUri);
  }
}
