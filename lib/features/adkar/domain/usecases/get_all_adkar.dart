import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/adkar/domain/entities/adkar_entity.dart';
import 'package:noor_quran/features/adkar/domain/repositories/adkar_repo.dart';

class GetAllAdkar {
  final AdkarRepo repository;

  GetAllAdkar(this.repository);

  Future<Either<Failure, List<AdkarEntity>>> call() async {
    return await repository.getAllAdkar();
  }
}
