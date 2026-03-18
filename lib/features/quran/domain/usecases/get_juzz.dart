import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/quran/data/models/juzz_model.dart';
import 'package:noor_quran/features/quran/domain/repositories/juzz_repository.dart';

class GetJuzz {
  JuzzRepository juzzRepository;
  GetJuzz(this.juzzRepository);

  Either<Failure, JuzzModel> call(int id) {
    return juzzRepository.getJuzz(id);
  }
}

class GetAllJuzz {
  JuzzRepository juzzRepository;
  GetAllJuzz(this.juzzRepository);

  Either<Failure, List<JuzzModel>> call() {
    return juzzRepository.getAllJuzz();
  }
}
