import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/adkar/domain/entities/adkar_entity.dart';
import 'package:noor_quran/features/adkar/domain/repositories/adkar_repo.dart';

class GetAdkarByCategory {
  final AdkarRepo repository;

  GetAdkarByCategory(this.repository);

  Future<Either<Failure, AdkarEntity>> call(String category) async {
    return await repository.getAdkarByCategory(category);
  }
}
