import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/hadith_entity.dart';
import '../../domain/repositories/hadith_repository.dart';
import '../datasources/hadith_local_data_source.dart';
import '../models/hadith.dart';

class HadithRepositoryImpl implements HadithRepository {
  final HadithLocalDataSource localDataSource;

  HadithRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<HadithEntity>>> getHadiths(HadithFiltersEntity filters) async {
    try {
      final models = await localDataSource.getHadiths(filters);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HadithEntity>> addHadith(HadithEntity entity) async {
    try {
      final model = Hadith.fromEntity(entity);
      final savedModel = await localDataSource.saveHadith(model);
      return Right(savedModel.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HadithEntity>> updateHadith(HadithEntity entity) async {
    try {
       final model = Hadith.fromEntity(entity);
       final savedModel = await localDataSource.saveHadith(model);
       return Right(savedModel.toEntity());
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
}
