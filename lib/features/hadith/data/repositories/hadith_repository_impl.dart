import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/hadith_entity.dart';
import '../../domain/repositories/hadith_repository.dart';
import '../datasources/hadith_local_data_source.dart';

class HadithRepositoryImpl implements HadithRepository {
  final HadithLocalDataSource localDataSource;

  HadithRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, HadithEntity>> addHadith(HadithEntity hadith) async {
    try {
      final result = await localDataSource.saveHadith(hadith);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteHadith(int id) async {
    try {
      await localDataSource.deleteHadith(id);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HadithEntity>>> getHadiths(
    HadithFiltersEntity filters,
  ) async {
    try {
      final result = await localDataSource.getHadiths(filters);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HadithEntity>> updateHadith(
    HadithEntity hadith,
  ) async {
    try {
      final result = await localDataSource.saveHadith(hadith);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
