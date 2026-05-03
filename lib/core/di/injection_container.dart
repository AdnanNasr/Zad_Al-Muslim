import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:zad_al_muslim/core/utils/location/location_locator.dart';
import 'package:zad_al_muslim/core/utils/network/network_info.dart';
import 'package:zad_al_muslim/features/pray_time/data/datasources/prayer_times_local_data_source.dart';
import 'package:zad_al_muslim/features/pray_time/data/datasources/user_address_local_data_source.dart';
import 'package:zad_al_muslim/features/pray_time/data/datasources/user_address_remote_data_source.dart';
import 'package:zad_al_muslim/features/pray_time/data/repositories/user_address_impl.dart';
import 'package:zad_al_muslim/features/pray_time/domain/repositories/user_address.dart';
import 'package:zad_al_muslim/features/pray_time/domain/usecases/get_user_address.dart';
import 'package:zad_al_muslim/features/quran/data/datasources/juzz_local.dart';
import 'package:zad_al_muslim/features/quran/data/datasources/surah_name_by_page_number_data.dart';
import 'package:zad_al_muslim/features/quran/data/datasources/surahs_meta_local.dart';
import 'package:zad_al_muslim/features/quran/data/datasources/voice_ayah_by_ayah_remote.dart';
import 'package:zad_al_muslim/features/quran/data/repositories/juzz_repository_impl.dart';
import 'package:zad_al_muslim/features/quran/data/repositories/surah_meta_impl.dart';
import 'package:zad_al_muslim/features/quran/data/repositories/surah_name_by_page_number_impl.dart';
import 'package:zad_al_muslim/features/quran/data/repositories/voice_ayah_by_ayah_impl.dart';
import 'package:zad_al_muslim/features/quran/domain/repositories/juzz_repository.dart';
import 'package:zad_al_muslim/features/quran/domain/repositories/surahs_meta_repository.dart';
import 'package:zad_al_muslim/features/quran/domain/usecases/get_juzz.dart';
import 'package:zad_al_muslim/features/quran/domain/usecases/get_surah_number_by_page_number.dart';
import 'package:zad_al_muslim/features/quran/domain/usecases/get_surahs_meta.dart';
import 'package:zad_al_muslim/features/quran/domain/usecases/get_voice_ayah_by_ayah.dart';
import 'package:zad_al_muslim/features/quran_moratal/data/datasources/surah_qari_remote_sources.dart';
import 'package:zad_al_muslim/features/quran_moratal/data/repositories/surah_qari_voice_impl.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/usecases/get_surah_qari_voice.dart';
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
import '../../features/adkar/data/repositories/adkar_impl.dart';
import '../../features/adkar/domain/repositories/adkar_repo.dart';
import '../../features/adkar/domain/usecases/get_all_adkar.dart';
import '../../features/adkar/domain/usecases/get_adkar_by_category.dart';
import '../../core/database/isar_db.dart';
import '../../features/qebla/data/repositories/qibla_repository_impl.dart';
import '../../features/qebla/domain/repositories/qibla_repository.dart';
import '../../features/qebla/domain/usecases/get_qibla_direction.dart';

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
  sl.registerLazySingleton<PrayerTimesLocalDataSource>(
    () => PrayerTimesLocalDataSourceImpl(),
  );

  // Notification Service
  sl.registerLazySingleton<IPrayerNotificationService>(
    () => PrayerNotificationServiceImpl(sl()),
  );

  // Get Adress

  // Local Datasource
  sl.registerLazySingleton<UserAddressLocalDataSource>(
    () => UserAddressLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<UserAddressRemoteDataSource>(
    () => UserAddressRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<UserAddressRepository>(
    () => UserAddressImpl(sl(), sl(), sl()),
  );

  sl.registerLazySingleton<GetUserAddress>(() => GetUserAddress(sl()));

  // User Position
  sl.registerLazySingleton<LocationLocator>(() => LocationLocatorImpl(sl()));
  sl.registerLazySingleton<LocationLocatorImpl>(
    () => LocationLocatorImpl(sl()),
  );

  // Features - Pray Time
  // ... (previous registrations)

  // Features - Tafsir
  // Use cases
  sl.registerLazySingleton(() => GetAyahTafsserUseCase(sl()));
  sl.registerLazySingleton(() => GetTafsserBooksUseCase(sl()));
  sl.registerLazySingleton(() => DownloadTafsserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TafsserRepository>(
    () => TafsserRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
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

  // Features - Quran
  sl.registerLazySingleton<SurahsMetaLocalImpl>(() => SurahsMetaLocalImpl());
  sl.registerLazySingleton<SurahsDataRepository>(
    () => SurahsMetaRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetSurahsMeta>(() => GetSurahsMeta(sl()));

  sl.registerLazySingleton<JuzzLocalImpl>(() => JuzzLocalImpl());
  sl.registerLazySingleton<JuzzRepository>(() => JuzzRepositoryImpl(sl()));
  sl.registerLazySingleton<GetJuzz>(() => GetJuzz(sl()));
  sl.registerLazySingleton<GetAllJuzz>(() => GetAllJuzz(sl()));

  // get sruah by page number
  sl.registerLazySingleton<SurahNameByPageNumberDataImpl>(
    () => SurahNameByPageNumberDataImpl(),
  );
  sl.registerLazySingleton<SurahNameByPageNumberImpl>(
    () => SurahNameByPageNumberImpl(sl()),
  );
  sl.registerLazySingleton<GetSurahNumberByPageNumber>(
    () => GetSurahNumberByPageNumber(sl()),
  );

  // voice ayah by ayah
  sl.registerLazySingleton<VoiceAyahByAyahImpl>(
    () => VoiceAyahByAyahImpl(sl()),
  );
  sl.registerLazySingleton<VoiceAyahByAyahRemoteImpl>(
    () => VoiceAyahByAyahRemoteImpl(),
  );
  sl.registerLazySingleton<GetVoiceAyahByAyah>(() => GetVoiceAyahByAyah(sl()));

  // Qari Moratal
  sl.registerLazySingleton<SurahQariRemoteSourcesImpl>(
    () => SurahQariRemoteSourcesImpl(),
  );
  sl.registerLazySingleton<SurahQariVoiceImpl>(() => SurahQariVoiceImpl(sl()));
  sl.registerLazySingleton<GetSurahQariVoice>(() => GetSurahQariVoice(sl()));

  // Features - Adkar
  sl.registerLazySingleton<AdkarRepo>(() => AdkarImpl());
  sl.registerLazySingleton<GetAllAdkar>(() => GetAllAdkar(sl()));
  sl.registerLazySingleton<GetAdkarByCategory>(() => GetAdkarByCategory(sl()));

  // Feature - Qibla
  sl.registerLazySingleton<QiblaRepository>(() => QiblaRepositoryImpl());
  sl.registerLazySingleton<GetQiblaDirection>(() => GetQiblaDirection(sl()));
}
