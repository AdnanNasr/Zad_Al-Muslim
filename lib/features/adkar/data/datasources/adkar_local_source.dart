import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/adkar/data/models/adkar_model.dart';

abstract class AdkarLocalSourceRepo {
  Future<Either<Failure, AdkarModel>> getOneAdkar(int id);
  Future<Either<Failure, List<AdkarModel>>> getAllAdkar();
}

class AdkarLocalSourceImpl extends AdkarLocalSourceRepo {
  @override
  Future<Either<Failure, List<AdkarModel>>> getAllAdkar() {
    // TODO: implement getAllAdkar
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AdkarModel>> getOneAdkar(int id) {
    // TODO: implement getOneAdkar
    throw UnimplementedError();
  }
}
