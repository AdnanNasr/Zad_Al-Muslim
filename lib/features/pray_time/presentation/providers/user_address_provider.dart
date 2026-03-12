import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/common/providers/network_info_provider.dart';
import 'package:noor_quran/core/common/providers/user_position_provider.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/features/pray_time/domain/entities/user_address_entity.dart';
import 'package:noor_quran/core/utils/location/location_locator.dart';

import 'package:noor_quran/features/pray_time/domain/usecases/get_user_address.dart';

final userAddressProvider =
    AsyncNotifierProvider<UserAddressNotifier, UserAddressEntity?>(() {
      return UserAddressNotifier();
    });

class UserAddressNotifier extends AsyncNotifier<UserAddressEntity?> {
  @override
  FutureOr<UserAddressEntity?> build() async {
    // مراقبة حالة الانترنت
    ref.watch(networkInfoProvider);

    // مراقبة موقع المستخدم
    final position = ref.watch(userPositionProvider);
    final locationLocator = sl<LocationLocatorImpl>();

    // 1. محاولة جلب العنوان من الكاش أولاً
    final cachedAddress = await locationLocator.getAddress();
    if (cachedAddress['country'] != null) {
      return UserAddressEntity(
        country: cachedAddress['country']!,
        locality: cachedAddress['locality'] ?? '',
      );
    }

    // 2. إذا لم يوجد كاش، نحاول جلبه من الإنترنت باستخدام الموقع
    if (position != null) {
      return await _fetchAddress(position.latitude, position.longitude);
    }

    return null;
  }

  // دالة مساعدة لجلب البيانات من الـ UseCase والتعامل مع النتائج
  Future<UserAddressEntity?> _fetchAddress(double lat, double long) async {
    final getUserAddress = sl<GetUserAddress>();
    final result = await getUserAddress(
      UserAddressParams(lat: lat, long: long),
    );

    return result.fold((failure) {
      // في حال الفشل (مثلاً لا يوجد إنترنت لأول مرة)
      return null;
    }, (address) async {
       // حفظ العنوان في الكاش للتشغيلات القادمة
      final locationLocator = sl<LocationLocatorImpl>();
      await locationLocator.saveAddress(
        country: address.country,
        locality: address.locality,
        countryCode: address.countryCode,
      );
      return address;
    });

  }


  Future<void> refresh () async {
    state = const AsyncLoading();
    ref.invalidateSelf();
    await future;
  }
}
