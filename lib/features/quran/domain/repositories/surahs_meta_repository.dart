import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/quran/domain/entities/surah_meta_entity.dart';

abstract class SurahsDataRepository {
  Either<Failure, List<SurahMetaEntity>> getSurahsName();
}