import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/pray_time/data/datasources/user_address_local_data_source.dart';
import 'package:noor_quran/features/pray_time/data/datasources/user_address_remote_data_source.dart';
import 'package:noor_quran/features/pray_time/domain/entities/user_address_entity.dart';
import 'package:noor_quran/features/pray_time/domain/repositories/user_address.dart';

class UserAddressImpl implements UserAddressRepository {
  final UserAddressRemoteDataSource _remoteDataSource;
  final UserAddressLocalDataSource _localDataSource;

  UserAddressImpl(this._remoteDataSource, this._localDataSource);
  @override
  Future<Either<Failure, UserAddressEntity>> getUserCityAndCountry(
    double lat,
    double long,
  ) async {
    try {
      final userAddressFromLocal = await _localDataSource.getUserAddress();

      if (userAddressFromLocal?.country == null &&
          userAddressFromLocal?.locality == null) {
        final userAddressRemote = await _remoteDataSource.getAddressFromCoords(
          lat,
          long,
        );

        if (userAddressRemote.country != null &&
            userAddressRemote.locality != null) {
          await _localDataSource.saveUserAddress(userAddressRemote);
          return Right(userAddressRemote.toEntity());
        }

        return Left(LocationFailure("تعذر تحديد العنوان بدقة"));
      } else {
        return Right(userAddressFromLocal!.toEntity());
      }
    } catch (e) {
      return Left(LocationFailure("حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }
}
