import 'package:flutter/widgets.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/schedule_notifications_usecase.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final ScheduleNotificationsUseCase scheduleNotificationsUseCase;
  final SharedPreferences sharedPreferences;

  AppLifecycleObserver({
    required this.scheduleNotificationsUseCase,
    required this.sharedPreferences,
  });

  static const String _lastTimezoneKey = 'last_known_timezone';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndSchedule();
    }
  }

  Future<void> _checkAndSchedule() async {
    try {
      final currentTimezone = (await FlutterTimezone.getLocalTimezone()).toString();
      final lastTimezone = sharedPreferences.getString(_lastTimezoneKey);

      bool timezoneChanged = lastTimezone != currentTimezone;
      
      // Call the use case. It internally checks for the 20-hour window
      // but we force it if the timezone has changed.
      await scheduleNotificationsUseCase(force: timezoneChanged);

      if (timezoneChanged) {
        await sharedPreferences.setString(_lastTimezoneKey, currentTimezone);
      }
    } catch (e) {
      // Log error or handle silently as this is a background-ish task
    }
  }
}
