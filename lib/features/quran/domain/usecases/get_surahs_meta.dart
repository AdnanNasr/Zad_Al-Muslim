import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/quran/domain/entities/surah_meta_entity.dart';
import 'package:zad_al_muslim/features/quran/domain/repositories/surahs_meta_repository.dart';

class GetSurahsMeta {
  SurahsDataRepository repository;
  GetSurahsMeta(this.repository);

  Either<Failure, List<SurahMetaEntity>> call() {
    return repository.getSurahsName();
  }
}