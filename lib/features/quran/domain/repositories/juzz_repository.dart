import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/quran/data/models/juzz_model.dart';

abstract class JuzzRepository {
  Either<Failure, List<JuzzModel>> getAllJuzz();
  Either<Failure, JuzzModel> getJuzz(int id);
}
