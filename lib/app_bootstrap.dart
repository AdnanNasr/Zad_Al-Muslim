import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:zad_al_muslim/core/di/injection_container.dart' as di;
import 'package:zad_al_muslim/core/utils/notifications/notification_service.dart';
import 'package:zad_al_muslim/infrastructure/repositories/notification_scheduler_impl.dart';
import 'package:zad_al_muslim/infrastructure/lifecycle/app_lifecycle_observer.dart';
import 'package:zad_al_muslim/features/quran/domain/services/quran_search_indexer.dart';

class AppBootstrap {
  static Future<void> init() async {
    // Timezone
    tz.initializeTimeZones();

    // Audio background
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'زاد المسلم - تشغيل الصوت',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      androidResumeOnClick: true,
    );

    // DI
    await di.init();

    // Notifications
    await NotificationService.init();

    // Scheduler
    await di.sl<NotificationSchedulerImpl>().init();

    // Lifecycle observer
    WidgetsBinding.instance.addObserver(di.sl<AppLifecycleObserver>());

    // Quran Search Indexer
    await QuranSearchIndexer.initialize();
  }
}
