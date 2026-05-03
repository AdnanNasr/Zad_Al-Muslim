import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/adkar/data/models/adkar_model.dart';
import 'package:zad_al_muslim/features/adkar/domain/entities/adkar_entity.dart';
import 'package:zad_al_muslim/features/adkar/domain/repositories/adkar_repo.dart';

class AdkarImpl extends AdkarRepo {
  final Isar db = sl<Isar>();

  @override
  Future<Either<Failure, List<AdkarEntity>>> getAllAdkar() async {
    try {
      final models = await db.adkarModels.where().findAll();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdkarEntity>> getOneAdkar(int id) async {
    try {
      final model = await db.adkarModels.get(id);
      if (model != null) {
        return Right(model.toEntity());
      } else {
        return Left(ServerFailure("الذكر غير موجود"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdkarEntity>> getAdkarByCategory(
    String category,
  ) async {
    try {
      final model = await db.adkarModels
          .filter()
          .categoryEqualTo(category)
          .findFirst();
      if (model != null) {
        return Right(model.toEntity());
      } else {
        return Left(ServerFailure("التصنيف غير موجود"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
