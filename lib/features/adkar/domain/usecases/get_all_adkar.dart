import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/adkar/domain/entities/adkar_entity.dart';
import 'package:zad_al_muslim/features/adkar/domain/repositories/adkar_repo.dart';

class GetAllAdkar {
  final AdkarRepo repository;

  GetAllAdkar(this.repository);

  Future<Either<Failure, List<AdkarEntity>>> call() async {
    return await repository.getAllAdkar();
  }
}
