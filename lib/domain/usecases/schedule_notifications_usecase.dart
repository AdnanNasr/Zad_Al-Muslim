import '../repositories/i_notification_scheduler.dart';
import '../repositories/i_prayer_repository.dart';

class ScheduleNotificationsUseCase {
  final IPrayerRepository _prayerRepository;
  final INotificationScheduler _notificationScheduler;

  ScheduleNotificationsUseCase(
    this._prayerRepository,
    this._notificationScheduler,
  );

  /// Schedules notifications for the next 7 days.
  /// [force] if true, bypasses the check for redundant scheduling.
  Future<void> call({bool force = false}) async {
    final now = DateTime.now().toUtc();
    
    // Optimization: Skip if already scheduled recently (unless forced)
    if (!force) {
      final lastSchedule = await _prayerRepository.getLastScheduleDate();
      if (lastSchedule != null) {
        // If last schedule was less than 20 hours ago, skip
        final difference = now.difference(lastSchedule).inHours;
        if (difference < 20) {
          return;
        }
      }
    }

    final to = now.add(const Duration(days: 7));
    final prayers = await _prayerRepository.getPrayersForRange(now, to);
    
    final futurePrayers = prayers.where((prayer) {
      final bufferTime = now.add(const Duration(minutes: 2));
      return prayer.utcTime.isAfter(bufferTime);
    }).toList();

    await _notificationScheduler.cancelAll();
    await _notificationScheduler.scheduleAll(futurePrayers);
    
    await _prayerRepository.saveLastScheduleDate(now);
  }
}
