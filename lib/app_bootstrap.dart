import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:zad_al_muslim/core/di/injection_container.dart' as di;
import 'package:zad_al_muslim/core/utils/notifications/notification_service.dart';
import 'package:zad_al_muslim/infrastructure/repositories/notification_scheduler_impl.dart';
import 'package:zad_al_muslim/infrastructure/lifecycle/app_lifecycle_observer.dart';
import 'package:zad_al_muslim/features/quran/domain/services/quran_search_indexer.dart';

// Imports needed for initializeAppData
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:zad_al_muslim/features/hadith/data/models/hadith_model.dart';
import 'package:zad_al_muslim/features/hadith/data/repositories/insert_hadith.dart';
import 'package:zad_al_muslim/features/quran/data/repositories/insert_quran_pages.dart';
import 'package:zad_al_muslim/features/tafsser/data/repositories/insert_tafsser.dart';
import 'package:zad_al_muslim/features/adkar/data/repositories/insert_adkar_to_isar.dart';
import 'package:zad_al_muslim/core/utils/location/location_locator.dart';
import 'package:zad_al_muslim/core/common/providers/user_position_provider.dart';
import 'package:zad_al_muslim/core/utils/location/providers/location_status_provider.dart';
import 'package:zad_al_muslim/core/constants/enums/my_enums.dart';
import 'package:zad_al_muslim/infrastructure/services/permission_service.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:zad_al_muslim/domain/usecases/recalculate_and_schedule_usecase.dart';
import 'package:zad_al_muslim/domain/entities/location.dart' as domain_loc;
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';
import 'package:zad_al_muslim/features/splash/presentation/pages/onboarding/onboarding_init.dart';

class AppBootstrap {
  /// ─────────────────────────────────────────────────────────────────
  /// [init] — العمليات التي يجب أن تكتمل قبل runApp()
  /// قاعدة: يُضاف هنا فقط ما يمنع ظهور الشاشة الأولى بدونه.
  /// ─────────────────────────────────────────────────────────────────
  static Future<void> init() async {
    // Timezone: ضروري لحساب مواقيت الصلاة والإشعارات
    tz.initializeTimeZones();

    // DI: ضروري لكل الـ services الأخرى
    await di.init();
  }

  /// ─────────────────────────────────────────────────────────────────
  /// [initCriticalData] — تهيئة البيانات الأساسية (DB) قبل runApp()
  /// يعمل فقط عند أول تثبيت للتطبيق (DB فارغة).
  /// ─────────────────────────────────────────────────────────────────
  static Future<void> initCriticalData() async {
    try {
      final isar = di.sl<Isar>();
      final hadithCount = await isar.hadiths.count();

      if (hadithCount == 0) {
        // أول تشغيل: لا مفر من إدخال البيانات قبل runApp
        await insertQuranPagesToIsar();
        await insertHadithToIsar();
        await loadTafsserFromAssest();
        await insertAdkarToIsar();
      }
    } catch (e) {
      AppLogger.logger.e('خطأ في initCriticalData: $e');
    }
  }

  /// ─────────────────────────────────────────────────────────────────
  /// [initDeferred] — عمليات مؤجلة تعمل بعد ظهور الـ UI
  /// استدعِها عبر: unawaited(AppBootstrap.initDeferred(container))
  /// ─────────────────────────────────────────────────────────────────
  static Future<void> initDeferred(ProviderContainer container) async {
    try {
      // 1. Audio background — يُحتاج فقط عند بدء تشغيل صوت
      await JustAudioBackground.init(
        androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
        androidNotificationChannelName: 'زاد المسلم - تشغيل الصوت',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        androidResumeOnClick: true,
      );

      // 2. Notifications: تُهيأ في الخلفية بعد ظهور الشاشة
      await NotificationService.init();
      await di.sl<NotificationSchedulerImpl>().init();

      // 3. Lifecycle observer
      WidgetsBinding.instance.addObserver(di.sl<AppLifecycleObserver>());

      // 4. Quran Search Index — ثقيل (6236 آية) لكنه يعمل في isolate منفصل
      //    بدأنا بـ unawaited لأنه لا يؤثر على الـ UI
      QuranSearchIndexer.initialize();

      // 5. الموقع ومواقيت الصلاة
      await _initLocationAndPrayers(container);
    } catch (e) {
      AppLogger.logger.e('خطأ في initDeferred: $e');
    }
  }

  /// ─────────────────────────────────────────────────────────────────
  /// منطق الموقع ومواقيت الصلاة (مُستخرج لوضوح الكود)
  /// ─────────────────────────────────────────────────────────────────
  static Future<void> _initLocationAndPrayers(
    ProviderContainer container,
  ) async {
    final locationLocator = di.sl<LocationLocatorImpl>();
    final cachedPos = await locationLocator.getLocationCoords();
    final hasSeen = await OnboardingInit.hasSeen();

    if (cachedPos != null) {
      container.read(userPositionProvider.notifier).state = cachedPos;

      // طلب الأذونات في الخلفية
      await di.sl<PermissionService>().requestAllPermissions();

      final tzName = (await FlutterTimezone.getLocalTimezone()).toString();
      final recalculateUseCase = di.sl<RecalculateAndScheduleUseCase>();

      await recalculateUseCase(
        domain_loc.Location(
          latitude: cachedPos.latitude,
          longitude: cachedPos.longitude,
          timezone: tzName,
        ),
      );
    } else if (hasSeen) {
      // مستخدم قديم بدون موقع مخزن
      await di.sl<PermissionService>().requestAllPermissions();
      final pos = await locationLocator.determinePosition();

      await pos.fold(
        (failure) async {
          container.read(locationStatusProvider.notifier).setStatus({
            LocationMessage.error: failure.message,
          });
        },
        (position) async {
          container.read(userPositionProvider.notifier).state = position;

          final tzName = (await FlutterTimezone.getLocalTimezone()).toString();
          final recalculateUseCase = di.sl<RecalculateAndScheduleUseCase>();

          await recalculateUseCase(
            domain_loc.Location(
              latitude: position.latitude,
              longitude: position.longitude,
              timezone: tzName,
            ),
          );
        },
      );
    }
  }
}
