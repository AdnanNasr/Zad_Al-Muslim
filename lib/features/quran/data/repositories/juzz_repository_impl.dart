import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/quran/data/datasources/juzz_local.dart';
import 'package:zad_al_muslim/features/quran/data/models/juzz_model.dart';
import 'package:zad_al_muslim/features/quran/domain/repositories/juzz_repository.dart';

class JuzzRepositoryImpl extends JuzzRepository {
  JuzzLocalImpl juzzLocal;
  JuzzRepositoryImpl(this.juzzLocal);
  @override
  Either<Failure, List<JuzzModel>> getAllJuzz() {
    return juzzLocal.getAllJuzz();
  }

  @override
  Either<Failure, JuzzModel> getJuzz(int id) {
    return juzzLocal.getJuzz(id);
  }
}
