import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/pray_time/domain/entities/user_address_entity.dart';

abstract class UserAddressRepository {
  Future<Either<Failure, UserAddressEntity>> getUserCityAndCountry(
    double lat,
    double long,
  );
}
