import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/hadith_entity.dart';
import '../repositories/hadith_repository.dart';

class UpdateHadithUseCase {
  final HadithRepository repository;

  UpdateHadithUseCase(this.repository);

  Future<Either<Failure, HadithEntity>> call(HadithEntity hadith) async {
    return await repository.updateHadith(hadith);
  }
}
