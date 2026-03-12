import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/core/utils/network/network_info.dart';
import 'package:noor_quran/features/pray_time/data/datasources/user_address_local_data_source.dart';
import 'package:noor_quran/features/pray_time/data/datasources/user_address_remote_data_source.dart';
import 'package:noor_quran/features/pray_time/domain/entities/user_address_entity.dart';
import 'package:noor_quran/features/pray_time/domain/repositories/user_address.dart';

class UserAddressImpl implements UserAddressRepository {
  final UserAddressRemoteDataSource _remoteDataSource;
  final UserAddressLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  UserAddressImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );
  @override
  Future<Either<Failure, UserAddressEntity>> getUserCityAndCountry(
    double lat,
    double long,
  ) async {
    try {
      // يتم جلب البيانات بشكل محلي في البداية
      final userAddressFromLocal = await _localDataSource.getUserAddress();

      if (userAddressFromLocal?.country == null &&
          userAddressFromLocal?.locality == null) {
        // اذا كان لا يوجد بيانات محلية بتم جلبها من الانترنت
        final hasInternetConnection = await _networkInfo.hasValidConnection();
        if (hasInternetConnection) {
          final userAddressRemote = await _remoteDataSource
              .getAddressFromCoords(lat, long);

          if (userAddressRemote.country != null &&
              userAddressRemote.locality != null) {
            await _localDataSource.saveUserAddress(userAddressRemote);
            return Right(userAddressRemote.toEntity());
          }
        }
        // اذا فشل جلب البيانات من الانترنت
        return Left(NetworkFailure("لا يوجد اتصال بالإنترنت"));
      } else {
        return Right(userAddressFromLocal!.toEntity());
      }
    } catch (e) {
      return Left(LocationFailure("حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }
}
