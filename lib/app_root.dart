import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/common/pages/home/home_page.dart';
import 'package:zad_al_muslim/core/common/pages/notifications_page.dart';
import 'package:zad_al_muslim/core/themes/app_theme.dart';
import 'package:zad_al_muslim/core/themes/theme_notifier.dart';
import 'package:zad_al_muslim/features/adkar/presentation/pages/adkar_page.dart';
import 'package:zad_al_muslim/features/hadith/presentation/pages/hadith_page.dart';
import 'package:zad_al_muslim/features/pray_time/presentation/pages/pray_time_page.dart';
import 'package:zad_al_muslim/features/qebla/presentation/pages/qebla_page.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/quran_pages.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/quran_settings_page.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/select_surah_page.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/pages/quran_moratal_page.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/providers/moratal_download_provider.dart';
import 'package:zad_al_muslim/features/settings/presentation/pages/app_info.dart';
import 'package:zad_al_muslim/features/settings/presentation/pages/change_app_color_page.dart';
import 'package:zad_al_muslim/features/settings/presentation/pages/settings_page.dart';
import 'package:zad_al_muslim/features/splash/presentation/pages/onboarding/onboarding_page.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/pages/tafseer_page.dart';
import 'package:zad_al_muslim/main.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../core/common/providers/theme_provider.dart';
import '../core/common/providers/language_provider.dart';
import '../features/quran/presentation/providers/mark.dart';
import '../core/l10n/app_localizations.dart';
import '../core/common/widgets/custom_navigation_bar.dart';

class AppRoot extends ConsumerStatefulWidget {
  final bool hasSeenOnboarding;
  const AppRoot({super.key, required this.hasSeenOnboarding});

  @override
  ConsumerState<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<AppRoot> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    Future.microtask(() async {
      await ref.read(themeProvider.notifier).loadTheme();
      await ref.read(userThemeProvider.notifier).loadScheme();
      await ref.read(languageProvider.notifier).loadlang();
      await ref.read(marksProvder.notifier).loadMarks();
    });

    moratalDownloadCompletedCallback = (qariId) {
      BotToast.cleanAll();

      BotToast.showCustomNotification(
        duration: const Duration(seconds: 5),

        align: const Alignment(0, 0.9),
        toastBuilder: (cancelFunc) {
          return Card(
            margin: EdgeInsets.all(16.w),

            color: const Color(0xFF1B8A5A),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  const Icon(
                    Icons.download_done_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  SizedBox(width: 10.w),
                  const Expanded(
                    child: Text(
                      'اكتمل التحميل! يمكنك الاستماع بدون إنترنت الآن. ✅',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final language = ref.watch(languageProvider);
    final userColor = ref.watch(userThemeProvider);

    return MaterialApp(
      navigatorKey: appNavigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      debugShowCheckedModeBanner: false,

      locale: Locale(language.name),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      themeMode: themeMode,

      theme: AppTheme.light(userColor),
      darkTheme: AppTheme.dark(userColor),
      initialRoute: widget.hasSeenOnboarding
          ? "/custom_navigation_bar"
          : "/onboarding",

      routes: {
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
