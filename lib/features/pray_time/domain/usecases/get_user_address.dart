import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/pray_time/domain/entities/user_address_entity.dart';
import 'package:noor_quran/features/pray_time/domain/repositories/user_address.dart';

class GetUserAddress {
  final UserAddressRepository repository;
  GetUserAddress(this.repository);
  Future<Either<Failure, UserAddressEntity>> call(
    UserAddressParams userAddressPramas,
  ) async {
    return await repository.getUserCityAndCountry(
      userAddressPramas.lat,
      userAddressPramas.long,
    );
  }
}

class UserAddressParams extends Equatable {
  final double lat;
  final double long;

  const UserAddressParams({required this.lat, required this.long});

  @override
  List<Object?> get props => [lat, long];
}
