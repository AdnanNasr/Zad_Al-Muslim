import 'package:geocoding/geocoding.dart';
import 'package:zad_al_muslim/features/pray_time/data/models/user_address_model.dart';

abstract class UserAddressRemoteDataSource {
  Future<UserAddressModel> getAddressFromCoords(double lat, double long);
}

class UserAddressRemoteDataSourceImpl implements UserAddressRemoteDataSource {
  @override
  Future<UserAddressModel> getAddressFromCoords(double lat, double long) async {
    final placemark = await placemarkFromCoordinates(lat, long);

    if (placemark.isNotEmpty) {
      final userAddress = UserAddressModel(
        country: placemark[0].country,
        locality: placemark[0].locality,
      );
      return userAddress;
    }
    return UserAddressModel(country: null, locality: null);
  }
}
