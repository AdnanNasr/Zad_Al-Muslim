import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/core/utils/location/location_locator.dart';
import 'package:noor_quran/core/utils/network/network_info.dart';
import 'package:noor_quran/features/pray_time/data/datasources/prayer_times_local_data_source.dart';
import 'package:noor_quran/features/pray_time/data/datasources/user_address_local_data_source.dart';
import 'package:noor_quran/features/pray_time/data/datasources/user_address_remote_data_source.dart';
import 'package:noor_quran/features/pray_time/data/repositories/user_address_impl.dart';
import 'package:noor_quran/features/pray_time/domain/repositories/user_address.dart';
import 'package:noor_quran/features/pray_time/domain/usecases/get_user_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/pray_time/data/repositories/prayer_notification_service_impl.dart';
import '../../features/pray_time/domain/repositories/prayer_notification_service.dart';
import '../../features/pray_time/data/repositories/prayer_times_repository_impl.dart';
import '../../features/pray_time/domain/repositories/prayer_times_repository.dart';
import '../../features/pray_time/domain/usecases/get_prayer_times_usecase.dart';
import '../../features/tafsser/data/datasource/tafsser_local_data_source.dart';
import '../../features/tafsser/data/datasource/tafsser_remote_data_source.dart';
import '../../features/tafsser/data/repositories/tafsser_repository_impl.dart';
import '../../features/tafsser/domain/repositories/tafsser_repository.dart';
import '../../features/tafsser/domain/usecases/get_ayah_tafsser_usecase.dart';
import '../../features/tafsser/domain/usecases/get_tafsser_books_usecase.dart';
import '../../features/tafsser/domain/usecases/download_tafsser_usecase.dart';
import '../../features/hadith/data/datasources/hadith_local_data_source.dart';
import '../../features/hadith/data/repositories/hadith_repository_impl.dart';
import '../../features/hadith/domain/repositories/hadith_repository.dart';
import '../../features/hadith/domain/usecases/get_hadiths_usecase.dart';
import '../../features/hadith/domain/usecases/update_hadith_usecase.dart';
import '../../core/database/isar_db.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final prefs = await SharedPreferences.getInstance();

  sl.registerSingleton<SharedPreferences>(prefs);

  await IsarDb.initDatabase();

  sl.registerSingleton<Isar>(IsarDb.database!);

  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo());



  // Features - Pray Time
  
  // Use cases
  sl.registerLazySingleton(() => GetPrayerTimesUseCase(sl()));
  
  // Repository
  sl.registerLazySingleton<PrayerTimesRepository>(
    () => PrayerTimesRepositoryImpl(
      localDataSource: sl(),
      notificationService: sl(),
    ),
  );

  // Datasource
  sl.registerLazySingleton<PrayerTimesLocalDataSource>(() => PrayerTimesLocalDataSourceImpl());
  
  // Notification Service
  sl.registerLazySingleton<IPrayerNotificationService>(
    () => PrayerNotificationServiceImpl(),
  );

  // Get Adress

  // Local Datasource
  sl.registerLazySingleton<UserAddressLocalDataSource>(() => UserAddressLocalDataSourceImpl(sl()));

  sl.registerLazySingleton<UserAddressRemoteDataSource>(() => UserAddressRemoteDataSourceImpl());

  sl.registerLazySingleton<UserAddressRepository>(() => UserAddressImpl(sl(), sl(), sl()));

  sl.registerLazySingleton<GetUserAddress>(() => GetUserAddress(sl()));

  // User Position
  sl.registerLazySingleton<LocationLocator>(() => LocationLocatorImpl(sl()));
  sl.registerLazySingleton<LocationLocatorImpl>(() => LocationLocatorImpl(sl()));
  
  // Features - Pray Time
  // ... (previous registrations)
  
  // Features - Tafsir
  // Use cases
  sl.registerLazySingleton(() => GetAyahTafsserUseCase(sl()));
  sl.registerLazySingleton(() => GetTafsserBooksUseCase(sl()));
  sl.registerLazySingleton(() => DownloadTafsserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TafsserRepository>(
    () => TafsserRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TafsserLocalDataSource>(
    () => TafsserLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<TafsserRemoteDataSource>(
    () => TafsserRemoteDataSourceImpl(sl()),
  );

  // Features - Hadith
  // Use cases
  sl.registerLazySingleton(() => GetHadithsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateHadithUseCase(sl()));

  // Repository
  sl.registerLazySingleton<HadithRepository>(
    () => HadithRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<HadithLocalDataSource>(
    () => HadithLocalDataSourceImpl(sl()),
  );
}
