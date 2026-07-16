import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:zad_al_muslim/app_root.dart';
import 'package:zad_al_muslim/app_bootstrap.dart';
import 'package:zad_al_muslim/features/splash/presentation/pages/onboarding/onboarding_init.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // إبقاء شاشة الإقلاع الأصلية ظاهرة أثناء التهيئة السريعة
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // ─── تهيئة سريعة: Timezone + DI فقط ────────────────────────────
  await AppBootstrap.init();

  // ─── إدخال البيانات الأولية (يعمل فقط أول مرة) ─────────────────
  await AppBootstrap.initCriticalData();

  // ─── التحقق من حالة Onboarding ───────────────────────────────────
  final hasSeenOnboarding = await OnboardingInit.hasSeen();

  // ─── إنشاء حاوية Riverpod ────────────────────────────────────────
  final container = ProviderContainer();

  // ─── تشغيل التطبيق فوراً ─────────────────────────────────────────
  runApp(
    ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(392.72727272727275, 800.7272727272727),
      builder: (_, _) => UncontrolledProviderScope(
        container: container,
        child: AppRoot(hasSeenOnboarding: hasSeenOnboarding),
      ),
    ),
  );

  // ─── التهيئة المؤجلة: تعمل في الخلفية بعد ظهور الـ UI ───────────
  // لا نستخدم await هنا عمداً حتى لا تحجب runApp
  AppBootstrap.initDeferred(container);
}
