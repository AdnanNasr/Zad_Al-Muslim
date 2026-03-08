import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/splash_screen.dart';
import 'package:noor_quran/core/themes/theme_notifier.dart';
import 'package:noor_quran/core/utils/notifications/notification_service.dart';
import 'package:noor_quran/view_models/logic/onboarding_storage.dart';
import 'package:noor_quran/view_models/models/db/isar_db.dart';
import 'package:noor_quran/view_models/providers/language_provider.dart';
import 'package:noor_quran/view_models/providers/quran_providers/mark.dart';
import 'package:noor_quran/view_models/providers/theme_provider.dart';
import 'package:noor_quran/views/pages/adkar_page.dart';
import 'package:noor_quran/views/pages/app_info.dart';
import 'package:noor_quran/views/pages/change_app_color_page.dart';
import 'package:noor_quran/views/pages/hadith_page.dart';
import 'package:noor_quran/views/pages/home_page.dart';
import 'package:noor_quran/views/pages/onboarding/onboarding_page.dart';
import 'package:noor_quran/views/pages/pray_time_page.dart';
import 'package:noor_quran/views/pages/qebla_page.dart';
import 'package:noor_quran/views/pages/settings_page.dart';
import 'package:noor_quran/views/pages/tafseer/tafseer_page.dart';
import 'package:noor_quran/views/widgets/custom_navigation_bar.dart';
import 'package:noor_quran/views/widgets/quran_page_app_bar.dart' ;
import "package:flutter_dotenv/flutter_dotenv.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // إعدادات البنية التحتية
  await IsarDb.initDatabase(); 
  await NotificationService.init();

  await dotenv.load(fileName: ".env");

  final container = ProviderContainer();

  // تحميل الإعدادات التي تؤثر على شكل التطبيق فوراً
  await container.read(themeProvider.notifier).loadTheme();
  await container.read(userThemeProvider.notifier).loadScheme();
  await container.read(languageProvider.notifier).loadlang();
  
  // تحميل العلامات المحفوظة
  await container.read(marksProvder.notifier).loadMarks();

  final hasSeen = await OnboardingStorage.hasSeen();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: ScreenUtilInit(
        minTextAdapt: true,
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
      locale: Locale(language.name),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      
      // البداية دائماً من السبلش
      initialRoute: "/splash_screen", 
      
      routes: {
        "/splash_screen": (_) => SplashScreen(hasSeenOnboarding: hasSeenOnboarding),
        "/home_page": (_) => const HomePage(),
        "/quran_pages": (_) => const QuranPageAppBar(),
        "/settings_page": (_) => const SettingsPage(),
        "/change_app_color_page": (_) => const ChangeAppColorPage(),
        "/tafseer_page": (_) => const TafseerPage(),
        "/app_info": (_) => const AppInfo(),
        "/sunah_page": (_) => const HadithPage(),
        "/onboarding": (_) => const OnboardingPage(),
        "/custom_navigation_bar": (_) => const CustomNavigationBar(),
        "/pray_time_page": (_) => PrayTimePage(),
        "/qebla_page": (_) => const QeblaPage(),
        "/adkar_page": (_) => const AdkarPage(),
      },
    );
  }
}