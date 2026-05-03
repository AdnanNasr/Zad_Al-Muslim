// import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:zad_al_muslim/core/common/pages/notifications_page.dart';
// import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:zad_al_muslim/core/l10n/app_localizations.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/quran_pages.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/quran_settings_page.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/select_surah_page.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/pages/quran_moratal_page.dart';
import 'package:zad_al_muslim/features/splash/presentation/pages/splash_screen.dart';
import 'package:zad_al_muslim/core/themes/theme_notifier.dart';
import 'package:zad_al_muslim/core/utils/notifications/notification_service.dart';
import 'package:zad_al_muslim/features/splash/presentation/pages/onboarding/onboarding_init.dart';
import 'package:zad_al_muslim/core/common/providers/language_provider.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart' as di;
import 'package:zad_al_muslim/features/quran/presentation/providers/mark.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';
import 'package:zad_al_muslim/features/adkar/presentation/pages/adkar_page.dart';
import 'package:zad_al_muslim/features/settings/presentation/pages/app_info.dart';
import 'package:zad_al_muslim/features/settings/presentation/pages/change_app_color_page.dart';
import 'package:zad_al_muslim/features/hadith/presentation/pages/hadith_page.dart';
import 'package:zad_al_muslim/core/common/pages/home/home_page.dart';
import 'package:zad_al_muslim/features/splash/presentation/pages/onboarding/onboarding_page.dart';
import 'package:zad_al_muslim/features/pray_time/presentation/pages/pray_time_page.dart';
import 'package:zad_al_muslim/features/qebla/presentation/pages/qebla_page.dart';
import 'package:zad_al_muslim/features/settings/presentation/pages/settings_page.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/pages/tafseer_page.dart';
import 'package:zad_al_muslim/core/common/widgets/custom_navigation_bar.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'زاد المسلم - تشغيل الصوت',
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true,
    androidResumeOnClick: true,
    // notificationColor: const Color(0xFF1E8449),
  );

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
        designSize: const Size(392.72727272727275, 800.7272727272727),
        // designSize: const Size(
        //   392.72727272727275,
        //   800.7272727272727,
        // ), // const Size(411.4, 853.3) && Size(392.72727272727275, 800.7272727272727)
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
    // final lightTheme = ref.watch(lightThemeProvider); // for colors in app
    // final darkTheme = ref.watch(darkThemeProvider); // for colors in app
    final themeMode = ref.watch(themeProvider);
    final language = ref.watch(languageProvider);

    return MaterialApp(
      locale: Locale(language.name),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E2E2E),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E2E2E),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: themeMode,

      // البداية دائماً من السبلش
      initialRoute: "/splash_screen",
      navigatorKey: appNavigatorKey,

      routes: {
        "/splash_screen": (_) =>
            SplashScreen(hasSeenOnboarding: hasSeenOnboarding),
        "/home_page": (_) => const HomePage(),
        "/quran_pages": (_) => const QuranPages(),
        "/quran_moratal": (_) => const QuranMoratalPage(),
        "/quran_settings_page": (_) => const QuranSettingsPage(),
        "/select_surah_page": (_) => const SelectSurahPage(),
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
        "/notifications_page": (_) => const NotificationsPage(),
      },
    );
  }
}
