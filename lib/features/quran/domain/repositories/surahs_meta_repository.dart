import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/quran/domain/entities/surah_meta_entity.dart';

abstract class SurahsDataRepository {
  Either<Failure, List<SurahMetaEntity>> getSurahsName();
}