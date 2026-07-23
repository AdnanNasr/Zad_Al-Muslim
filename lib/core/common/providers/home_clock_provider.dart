import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ساعة خفيفة للواجهة الرئيسية؛ تحدّث العناصر الزمنية مع بداية كل دقيقة.
final homeClockProvider = StreamProvider.autoDispose<DateTime>((ref) async* {
  while (true) {
    final now = DateTime.now();
    yield now;

    final nextMinute = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute + 1,
    );
    await Future<void>.delayed(nextMinute.difference(now));
  }
});
