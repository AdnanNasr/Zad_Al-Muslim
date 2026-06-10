import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/entities/surah_meta_moratal_entity.dart';

abstract class SurahMetaMoratalRepo {
  Future<Either<Failure, List<SurahMetaMoratalEntity>>> getSurahsName({
    required qariUri,
  });
}
