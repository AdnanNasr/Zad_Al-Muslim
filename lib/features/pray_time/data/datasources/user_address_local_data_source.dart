import 'package:noor_quran/features/pray_time/data/models/user_address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserAddressLocalDataSource {
  Future<void> saveUserAddress(UserAddressModel userAddress);
  Future<UserAddressModel?> getUserAddress();
}

class UserAddressLocalDataSourceImpl implements UserAddressLocalDataSource {
  static const _countryKey = "cached_country";
  static const _localityKey = "cached_locality";
  final SharedPreferences sharedPreferences;
  UserAddressLocalDataSourceImpl(this.sharedPreferences);
  @override
  Future<UserAddressModel?> getUserAddress() async {
    final country = sharedPreferences.getString(_countryKey);
    final locality = sharedPreferences.getString(_localityKey);

    if (country != null && locality != null) {
      return UserAddressModel(country: country, locality: locality);
    }

    return null;
  }

  @override
  Future<void> saveUserAddress(UserAddressModel userAddress) async {
    if (userAddress.country != null && userAddress.locality != null) {
      await sharedPreferences.setString(_countryKey, userAddress.country!);
      await sharedPreferences.setString(_localityKey, userAddress.locality!);
    }
  }
}
