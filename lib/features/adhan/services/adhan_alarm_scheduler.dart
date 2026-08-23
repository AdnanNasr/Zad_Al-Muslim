import 'dart:io';

import 'package:flutter/services.dart';
import 'package:zad_al_muslim/features/adhan/domain/reciter.dart';

/// Schedules Android's native receiver. It is intentionally separate from
/// notification channels: a long adhan is media playback, not a channel sound.
class AdhanAlarmScheduler {
  static const _channel = MethodChannel('com.zad_al_muslim.adnan/adhan_alarm');

  Future<void> schedule({
    required int id,
    required DateTime time,
    required bool isFajr,
    required AdhanReciter reciter,
  }) async {
    if (!Platform.isAndroid || !time.isAfter(DateTime.now())) return;
    await _channel.invokeMethod<void>('schedule', {
      'id': id,
      'timeMillis': time.millisecondsSinceEpoch,
      'asset': reciter.assetFor(isFajr: isFajr),
      'title': isFajr ? 'أذان الفجر' : 'حان وقت الصلاة',
    });
  }

  Future<void> cancel(int id) async {
    if (Platform.isAndroid)
      await _channel.invokeMethod<void>('cancel', {'id': id});
  }

  Future<void> cancelAll() async {
    if (Platform.isAndroid) await _channel.invokeMethod<void>('cancelAll');
  }
}
