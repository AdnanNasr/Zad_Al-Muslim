import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/adkar/domain/entities/adkar_entity.dart';
import 'package:zad_al_muslim/features/adkar/domain/repositories/adkar_repo.dart';

class GetAdkarByCategory {
  final AdkarRepo repository;

  GetAdkarByCategory(this.repository);

  Future<Either<Failure, AdkarEntity>> call(String category) async {
    return await repository.getAdkarByCategory(category);
  }
}
