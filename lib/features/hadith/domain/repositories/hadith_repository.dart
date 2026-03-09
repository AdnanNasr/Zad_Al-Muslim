import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/hadith_entity.dart';

abstract class HadithRepository {
  Future<Either<Failure, List<HadithEntity>>> getHadiths(HadithFiltersEntity filters);
  Future<Either<Failure, HadithEntity>> addHadith(HadithEntity hadith);
  Future<Either<Failure, HadithEntity>> updateHadith(HadithEntity hadith);
  Future<Either<Failure, Unit>> deleteHadith(int id);
}
