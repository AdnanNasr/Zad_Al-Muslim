import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/pray_time/domain/entities/user_address_entity.dart';

abstract class UserAddressRepository {
  Future<Either<Failure, UserAddressEntity>> getUserCityAndCountry(
    double lat,
    double long,
  );
}
