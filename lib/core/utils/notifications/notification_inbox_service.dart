import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        isRead: json['isRead'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead,
  };

  AppNotification markRead() => AppNotification(
    id: id,
    title: title,
    body: body,
    createdAt: createdAt,
    isRead: true,
  );
}

class NotificationInboxService {
  NotificationInboxService(this._prefs);

  static const _itemsKey = 'notification_inbox_items_v1';
  static const _oneTimeKey = 'notification_inbox_one_time_v1';
  static const _dailyKey = 'notification_inbox_daily_v1';
  static const _lastSyncKey = 'notification_inbox_last_sync_v1';

  final SharedPreferences _prefs;
  final ValueNotifier<List<AppNotification>> notifications = ValueNotifier([]);
  bool _loaded = false;

  int get unreadCount =>
      notifications.value.where((item) => !item.isRead).length;

  Future<void> init() async {
    await _ensureLoaded();
    await reconcile();
  }

  Future<void> replaceOneTimeSchedules(
    List<Map<String, dynamic>> schedules,
  ) async {
    await _ensureLoaded();
    await _prefs.setString(_oneTimeKey, jsonEncode(schedules));
  }

  Future<void> setDailySchedule({
    required String key,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await _ensureLoaded();
    final schedules = _readList(_dailyKey);
    schedules.removeWhere((item) => item['key'] == key);
    schedules.add({
      'key': key,
      'hour': hour,
      'minute': minute,
      'title': title,
      'body': body,
    });
    await _prefs.setString(_dailyKey, jsonEncode(schedules));
  }

  Future<void> removeDailySchedule(String key) async {
    await _ensureLoaded();
    final schedules = _readList(_dailyKey);
    schedules.removeWhere((item) => item['key'] == key);
    await _prefs.setString(_dailyKey, jsonEncode(schedules));
  }

  Future<void> addUpdateAvailable({
    required int buildNumber,
    required String title,
    required String body,
  }) async {
    await _ensureLoaded();
    await _addIfAbsent(
      id: 'optional_update_$buildNumber',
      title: title,
      body: body,
      createdAt: DateTime.now(),
    );
  }

  Future<void> reconcile() async {
    await _ensureLoaded();
    final now = DateTime.now();
    final lastSync =
        DateTime.tryParse(_prefs.getString(_lastSyncKey) ?? '') ?? now;

    for (final schedule in _readList(_oneTimeKey)) {
      final scheduledAt = DateTime.tryParse(
        schedule['scheduledAt'] as String? ?? '',
      );
      if (scheduledAt != null &&
          !scheduledAt.isAfter(now) &&
          scheduledAt.isAfter(lastSync)) {
        await _addIfAbsent(
          id: schedule['id'] as String,
          title: schedule['title'] as String,
          body: schedule['body'] as String,
          createdAt: scheduledAt,
        );
      }
    }

    // Daily notifications repeat natively; recreate the occurrences missed
    // while Dart was not running when the user returns to the app.
    for (final schedule in _readList(_dailyKey)) {
      final firstDay = DateTime(lastSync.year, lastSync.month, lastSync.day);
      final lastDay = DateTime(now.year, now.month, now.day);
      for (
        var day = firstDay;
        !day.isAfter(lastDay);
        day = day.add(const Duration(days: 1))
      ) {
        final occurrence = DateTime(
          day.year,
          day.month,
          day.day,
          schedule['hour'] as int,
          schedule['minute'] as int,
        );
        if (occurrence.isAfter(lastSync) && !occurrence.isAfter(now)) {
          await _addIfAbsent(
            id: '${schedule['key']}_${occurrence.toIso8601String()}',
            title: schedule['title'] as String,
            body: schedule['body'] as String,
            createdAt: occurrence,
          );
        }
      }
    }

    await _prefs.setString(_lastSyncKey, now.toIso8601String());
  }

  Future<void> markAllRead() async {
    await _ensureLoaded();
    final updated = notifications.value.map((item) => item.markRead()).toList();
    await _saveItems(updated);
  }

  Future<void> deleteNotification(String id) async {
    await _ensureLoaded();
    await _saveItems(
      notifications.value
          .where((notification) => notification.id != id)
          .toList(),
    );
  }

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    _loaded = true;
    final decoded = _readList(_itemsKey);
    notifications.value =
        decoded.map((item) => AppNotification.fromJson(item)).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Map<String, dynamic>> _readList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return [];
    final value = jsonDecode(raw) as List<dynamic>;
    return value.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Future<void> _addIfAbsent({
    required String id,
    required String title,
    required String body,
    required DateTime createdAt,
  }) async {
    if (notifications.value.any((item) => item.id == id)) return;
    final updated = [
      AppNotification(
        id: id,
        title: title,
        body: body,
        createdAt: createdAt,
        isRead: false,
      ),
      ...notifications.value,
    ];
    await _saveItems(updated);
  }

  Future<void> _saveItems(List<AppNotification> items) async {
    notifications.value = items;
    await _prefs.setString(
      _itemsKey,
      jsonEncode(items.map((item) => item.toJson()).toList()),
    );
  }
}
