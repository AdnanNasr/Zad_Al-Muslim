// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/l10n/app_localizations.dart';
import 'package:noor_quran/view_models/models/db/isar_db.dart';
import 'package:noor_quran/themes/theme_notifier.dart';
import 'package:noor_quran/view_models/providers/language_provider.dart';
import 'package:noor_quran/view_models/providers/quran_providers/mark.dart';
import 'package:noor_quran/view_models/providers/theme_provider.dart';
import 'package:noor_quran/view_models/repositories/insert_hadith.dart';
import 'package:noor_quran/view_models/repositories/insert_quran_pages.dart';
import 'package:noor_quran/view_models/logic/onboarding_storage.dart';
import 'package:noor_quran/view_models/repositories/insert_tafsser.dart';
import 'package:noor_quran/views/pages/adkar_page.dart';
import 'package:noor_quran/views/pages/app_info.dart';
import 'package:noor_quran/views/pages/change_app_color_page.dart';
import 'package:noor_quran/views/pages/home_page.dart';
import 'package:noor_quran/views/pages/onboarding/onboarding_page.dart';
import 'package:noor_quran/views/pages/pray_time_page.dart';
import 'package:noor_quran/views/pages/qebla_page.dart';
import 'package:noor_quran/views/pages/settings_page.dart';
import 'package:noor_quran/views/pages/hadith_page.dart';
import 'package:noor_quran/views/pages/tafseer/tafseer_page.dart';
import 'package:noor_quran/views/widgets/custom_navigation_bar.dart';
import 'package:noor_quran/views/widgets/quran_page_app_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarDb.initDatabase(); // تهيئة قاعدة البيانات المحلية وفتحها
  await insertQuranPagesToIsar(); // إضافة جميع بيانات القران الى قاعدة البيانات
  await insertHadithToIsar(); // اضافة جميع بيانات الحديث الى قاعدة البيانات
  await loadTafsserFromAssest(); // اضافة جميع بيانات التفاسير قاعدة البيانات
  final container = ProviderContainer();
  await container
      .read(themeProvider.notifier)
      .loadTheme(); // Dont forget to dispose the container
  await container.read(userThemeProvider.notifier).loadScheme();
  await container.read(languageProvider.notifier).loadlang();
  await container.read(marksProvder.notifier).loadMarks();
  final hasSeen = await OnboardingStorage.hasSeen();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: ScreenUtilInit(
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        designSize: const Size(411.4, 853.3),
        builder: (context, child) => MyApp(hasSeenOnboarding: hasSeen),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final bool hasSeenOnboarding;
  const MyApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);
    final themeMode = ref.watch(themeProvider);
    final language = ref.watch(languageProvider);
    return MaterialApp(
      // builder: (context, child) => DevicePreview.appBuilder(context, child),
      locale: Locale(language.name),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      initialRoute: hasSeenOnboarding
          ? "/custom_navigation_bar"
          : "/onboarding",
      // home: const OnboardingPage(),
      routes: {
        "/home_page": (_) => const HomePage(),
        "/quran_pages": (_) => const QuranPageAppBar(),
        "/settings_page": (_) => const SettingsPage(),
        "/change_app_color_page": (_) => const ChangeAppColorPage(),
        "/tafseer_page": (_) => const TafseerPage(),
        "/app_info": (_) => const AppInfo(),
        "/sunah_page": (_) => const HadithPage(),
        "/onboarding": (_) => const OnboardingPage(),
        "/custom_navigation_bar": (_) => const CustomNavigationBar(),
        "/pray_time_page": (_) => const PrayTimePage(),
        "/qebla_page": (_) => const QeblaPage(),
        "/adkar_page": (_) => const AdkarPage(),
      },
    );
  }
}
