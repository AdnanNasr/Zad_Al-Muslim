import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/features/quran/presentation/pages/quran_pages.dart';
import 'package:noor_quran/features/quran/presentation/pages/select_surah_page.dart';
import 'package:noor_quran/features/splash/presentation/pages/splash_screen.dart';
import 'package:noor_quran/core/themes/theme_notifier.dart';
import 'package:noor_quran/core/utils/notifications/notification_service.dart';
import 'package:noor_quran/features/splash/presentation/pages/onboarding/onboarding_init.dart';
import 'package:noor_quran/core/common/providers/language_provider.dart';
import 'package:noor_quran/core/di/injection_container.dart' as di;
import 'package:noor_quran/features/quran/presentation/providers/mark.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';
import 'package:noor_quran/features/adkar/presentation/pages/adkar_page.dart';
import 'package:noor_quran/features/settings/presentation/pages/app_info.dart';
import 'package:noor_quran/features/settings/presentation/pages/change_app_color_page.dart';
import 'package:noor_quran/features/hadith/presentation/pages/hadith_page.dart';
import 'package:noor_quran/core/common/pages/home/home_page.dart';
import 'package:noor_quran/features/splash/presentation/pages/onboarding/onboarding_page.dart';
import 'package:noor_quran/features/pray_time/presentation/pages/pray_time_page.dart';
import 'package:noor_quran/features/qebla/presentation/pages/qebla_page.dart';
import 'package:noor_quran/features/settings/presentation/pages/settings_page.dart';
import 'package:noor_quran/features/tafsser/presentation/pages/tafseer_page.dart';
import 'package:noor_quran/core/common/widgets/custom_navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dependency Injection
  await di.init();

  await NotificationService.init();

  final container = ProviderContainer();

  // تحميل الإعدادات التي تؤثر على شكل التطبيق فوراً
  await container.read(themeProvider.notifier).loadTheme();
  await container.read(userThemeProvider.notifier).loadScheme();
  await container.read(languageProvider.notifier).loadlang();

  // تحميل العلامات المحفوظة
  await container.read(marksProvder.notifier).loadMarks();

  final hasSeen = await OnboardingInit.hasSeen();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: ScreenUtilInit(
        minTextAdapt: true,
        designSize: const Size(
          392.72,
          800.72,
        ), // const Size(411.4, 853.3) && Size(392.72727272727275, 800.7272727272727)
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
        "/splash_screen": (_) =>
            SplashScreen(hasSeenOnboarding: hasSeenOnboarding),
        "/home_page": (_) => const HomePage(),
        "/quran_pages": (_) => const QuranPages(),
        "/select_surah_page": (_) => SelectSurahPage(),
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
