import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:noor_quran/core/constants/shared_pref_keys.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/core/utils/log/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan/adhan.dart';
import 'package:geocoding/geocoding.dart';
import 'package:noor_quran/core/utils/network/network_info.dart';

abstract class LocationLocator {
  Future<Either<Failure, Position>> determinePosition();
  Future<void> saveLocationCoords(double lat, double long);
  Future<Position?> getLocationCoords();
  Future<void> saveAddress({
    required String country,
    required String locality,
    required String countryCode,
  });
  Future<Map<String, String?>> getAddress();
  Future<CalculationParameters> getCalculationParameters(
    double lat,
    double lng,
  );
}

class LocationLocatorImpl implements LocationLocator {
  final SharedPreferences sharedPreferences;
  LocationLocatorImpl(this.sharedPreferences);

  @override
  Future<Either<Failure, Position>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. فحص هل خدمة الـ GPS مفعلة
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      final cachedPos = await getLocationCoords();
      if (cachedPos != null) return Right(cachedPos);
      return Left(LocationFailure("يجب تفعيل الـ GPS من إعدادات الجوال"));
    }

    // 2. فحص أذونات الموقع
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        final cachedPos = await getLocationCoords();
        if (cachedPos != null) return Right(cachedPos);
        return Left(LocationFailure("تم رفض طلب إذن الموقع"));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      final cachedPos = await getLocationCoords();
      if (cachedPos != null) return Right(cachedPos);
      return Left(
        LocationFailure("الأذونات مرفوضة بشكل دائم، يرجى تفعيلها من الإعدادات"),
      );
    }

    // 3. جلب الموقع الفعلي
    try {
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      // حفظ الإحداثيات محلياً باستخدام setDouble
      await saveLocationCoords(position.latitude, position.longitude);

      return Right(position);
    } catch (e) {
      AppLogger.logger.e("فشل جلب الموقع: ${e.toString()}");

      final cachedPos = await getLocationCoords();
      if (cachedPos != null) {
        return Right(cachedPos);
      }

      return Left(
        LocationFailure("حدث خطأ أثناء تحديد الموقع، تأكد من الـ GPS"),
      );
    }
  }

  @override
  Future<void> saveLocationCoords(double lat, double long) async {
    await sharedPreferences.setDouble(SharedPrefKeys.lat, lat);
    await sharedPreferences.setDouble(SharedPrefKeys.long, long);
  }

  @override
  Future<Position?> getLocationCoords() async {
    final lat = sharedPreferences.getDouble(SharedPrefKeys.lat);
    final long = sharedPreferences.getDouble(SharedPrefKeys.long);

    if (lat != null && long != null) {
      return Position(
        latitude: lat,
        longitude: long,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
    return null;
  }

  @override
  Future<void> saveAddress({
    required String country,
    required String locality,
    required String countryCode,
  }) async {
    await sharedPreferences.setString(SharedPrefKeys.country, country);
    await sharedPreferences.setString(SharedPrefKeys.locality, locality);
    await sharedPreferences.setString(SharedPrefKeys.countryCode, countryCode);
  }

  @override
  Future<Map<String, String?>> getAddress() async {
    return {
      'country': sharedPreferences.getString(SharedPrefKeys.country),
      'locality': sharedPreferences.getString(SharedPrefKeys.locality),
      'countryCode': sharedPreferences.getString(SharedPrefKeys.countryCode),
    };
  }

  @override
  Future<CalculationParameters> getCalculationParameters(
    double lat,
    double lng,
  ) async {
    try {
      // 0. فحص الإعدادات اليدوية أولاً
      final int manualMethodIndex =
          sharedPreferences.getInt('calculation_method_key') ?? 0;
      final int manualMadhabIndex = sharedPreferences.getInt('madhab_key') ?? 0;

      CalculationParameters params;

      if (manualMethodIndex != 0) {
        // إذا اختار المستخدم طريقة يدوية
        switch (manualMethodIndex) {
          case 1:
            params = CalculationMethod.muslim_world_league.getParameters();
            break;
          case 2:
            params = CalculationMethod.umm_al_qura.getParameters();
            break;
          case 3:
            params = CalculationMethod.egyptian.getParameters();
            break;
          case 4:
            params = CalculationMethod.karachi.getParameters();
            break;
          case 5:
            params = CalculationMethod.turkey.getParameters();
            break;
          case 6:
            params = CalculationMethod.dubai.getParameters();
            break;
          case 7:
            params = CalculationMethod.moon_sighting_committee.getParameters();
            break; // corrected name
          case 8:
            params = CalculationMethod.north_america.getParameters();
            break;
          case 9:
            params = CalculationMethod.kuwait.getParameters();
            break;
          case 10:
            params = CalculationMethod.qatar.getParameters();
            break;
          case 11:
            params = CalculationMethod.singapore.getParameters();
            break;
          case 12:
            params = CalculationMethod.tehran.getParameters();
            break;
          default:
            params = CalculationMethod.muslim_world_league.getParameters();
        }
      } else {
        // المنطق التلقائي (بناءً على الدولة)
        final cached = await getAddress();
        String countryCode = cached['countryCode'] ?? '';

        if (countryCode.isEmpty) {
          try {
            final internetConnected = await NetworkInfo().hasValidConnection();
            if (internetConnected) {
              final placemarks = await placemarkFromCoordinates(lat, lng);
              if (placemarks.isNotEmpty) {
                final placemark = placemarks.first;
                countryCode = placemark.isoCountryCode ?? '';
                await saveAddress(
                  country: placemark.country ?? '',
                  locality: placemark.locality ?? '',
                  countryCode: countryCode,
                );
              }
            }
          } catch (e) {
            AppLogger.logger.e("فشل الحصول على العنوان من الإحداثيات: $e");
          }
        }

        switch (countryCode.toUpperCase()) {
          case 'SA':
            params = CalculationMethod.umm_al_qura.getParameters();
            break;
          case 'EG':
          case 'SD':
          case 'LY':
          case 'SY':
          case 'JO':
          case 'PS':
          case 'LB':
            params = CalculationMethod.egyptian.getParameters();
            break;
          case 'AE':
          case 'BH':
          case 'OM':
            params = CalculationMethod.dubai.getParameters();
            break;
          case 'KW':
            params = CalculationMethod.kuwait.getParameters();
            break;
          case 'QA':
            params = CalculationMethod.qatar.getParameters();
            break;
          case 'TR':
            params = CalculationMethod.turkey.getParameters();
            break;
          case 'PK':
          case 'AF':
          case 'IN':
          case 'BD':
            params = CalculationMethod.karachi.getParameters();
            params.madhab = Madhab.hanafi;
            break;
          case 'US':
          case 'CA':
          case 'MX':
            params = CalculationMethod.north_america.getParameters();
            break;
          case 'SG':
          case 'MY':
          case 'ID':
            params = CalculationMethod.singapore.getParameters();
            break;
          case 'IR':
          case 'IQ':
            params = CalculationMethod.tehran.getParameters();
            break;
          case 'RU':
          case 'UA':
            params = CalculationMethod.moon_sighting_committee
                .getParameters(); // corrected
            break;
          case 'MA':
          case 'DZ':
          case 'TN':
            params = CalculationParameters(fajrAngle: 19.0, ishaAngle: 17.0);
            break;
          default:
            params = CalculationMethod.muslim_world_league.getParameters();
        }
      }

      // تطبيق المذهب اليدوي إذا تم اختياره (إذا كان 1 يعني حنفي، وإذا كان 0 نتركه حسب الطريقة أو الافتراضي شافعي)
      if (manualMadhabIndex == 1) {
        params.madhab = Madhab.hanafi;
      } else if (manualMadhabIndex == 0 && manualMethodIndex != 0) {
        // إذا كان المذهب تلقائي والطريقة يدوية، نجعله شافعي كافتراضي (إلا لو كانت طريقة كراتشي يدوية ف dhan يتعامل معها)
        // لكن لضمان الوضوح:
        if (manualMethodIndex != 4) {
          // 4 is Karachi
          params.madhab = Madhab.shafi;
        }
      }

      return params;
    } catch (e) {
      AppLogger.logger.e("خطأ في تحديد بارامترات الحساب: $e");
      return CalculationMethod.muslim_world_league.getParameters();
    }
  }
}
