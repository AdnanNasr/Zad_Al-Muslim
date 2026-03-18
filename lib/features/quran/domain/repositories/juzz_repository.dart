import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/quran/data/models/juzz_model.dart';

abstract class JuzzRepository {
  Either<Failure, List<JuzzModel>> getAllJuzz();
  Either<Failure, JuzzModel> getJuzz(int id);
}
