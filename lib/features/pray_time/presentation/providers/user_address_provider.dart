import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/common/providers/user_position_provider.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/features/pray_time/domain/entities/user_address_entity.dart';
import 'package:noor_quran/features/pray_time/domain/usecases/get_user_address.dart';

final userAddressProvider =
    AsyncNotifierProvider<UserAddressNotifier, UserAddressEntity?>(() {
      return UserAddressNotifier();
    });

class UserAddressNotifier extends AsyncNotifier<UserAddressEntity?> {
  @override
  Future<UserAddressEntity?> build() async {
    final position = ref.watch(userPositionProvider);

    if (position != null) {
      return await _fetchAddressFromUseCase(
        position.latitude,
        position.longitude,
      );
    }

    return null;
    
  }

  Future<UserAddressEntity?> _fetchAddressFromUseCase(
    double lat,
    double long,
  ) async {
    final getUserAddress = sl<GetUserAddress>();
    final result = await getUserAddress(
      UserAddressParams(lat: lat, long: long),
    );

    return result.fold((failure) => null, (address) => address);
  }
}
