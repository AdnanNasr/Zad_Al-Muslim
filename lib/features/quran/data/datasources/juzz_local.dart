import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/constants/juz.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/quran/data/models/juzz_model.dart';

abstract class JuzzLocal {
  Either<Failure, List<JuzzModel>> getAllJuzz();
  Either<Failure, JuzzModel> getJuzz(int id);
}

class JuzzLocalImpl implements JuzzLocal {
  final juzz = juz;
  @override
  Either<Failure, List<JuzzModel>> getAllJuzz() {
    try {
      final listOfJuzz = juzz.map((m) => JuzzModel.fromMap(m)).toList();
      return Right(listOfJuzz);
    } catch (e) {
      return Left(DataFailure(e.toString()));
    }
  }

  @override
  Either<Failure, JuzzModel> getJuzz(int id) {
    try {
      for (int i = 0; i < juzz.length; i++) {
        final currentJuzMap = juzz[i];

        if (currentJuzMap['id'] == id) {
          return Right(JuzzModel.fromMap(currentJuzMap));
        }
      }
      return Left(DataFailure("لم يتم العثور على الجزء رقم $id"));
    } catch (e) {
      return Left(DataFailure(e.toString()));
    }
  }
}
