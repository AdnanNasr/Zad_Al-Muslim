import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/hadith_entity.dart';
import '../repositories/hadith_repository.dart';

class GetHadithsUseCase {
  final HadithRepository repository;

  GetHadithsUseCase(this.repository);

  Future<Either<Failure, List<HadithEntity>>> call(HadithFiltersEntity filters) async {
    return await repository.getHadiths(filters);
  }
}
