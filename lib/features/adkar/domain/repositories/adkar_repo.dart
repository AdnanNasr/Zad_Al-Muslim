import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/adkar/domain/entities/adkar_entity.dart';

abstract class AdkarRepo {
  Future<Either<Failure, AdkarEntity>> getOneAdkar(int id);
  Future<Either<Failure, List<AdkarEntity>>> getAllAdkar();
  Future<Either<Failure, AdkarEntity>> getAdkarByCategory(String category);
}
