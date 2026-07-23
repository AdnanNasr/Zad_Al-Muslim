import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ساعة يومية مشتركة.
///
/// ترسل قيمة جديدة عند بداية يوم جديد، حتى تتحدث الآية والدعاء
/// إذا بقي التطبيق مفتوحًا بعد منتصف الليل.
final dailyContentDateProvider = StreamProvider.autoDispose<DateTime>((
  ref,
) async* {
  var currentDate = _dateOnly(DateTime.now());

  yield currentDate;

  while (true) {
    final now = DateTime.now();

    final nextDay = DateTime(now.year, now.month, now.day + 1);

    final delay = nextDay.difference(now);

    await Future<void>.delayed(delay);

    currentDate = _dateOnly(DateTime.now());

    yield currentDate;
  }
});

/// يوفر آية يومية تتغير كل يوم بناءً على التاريخ.
final dailyVerseProvider = FutureProvider.autoDispose<Map<String, dynamic>>((
  ref,
) async {
  final dateAsync = ref.watch(dailyContentDateProvider);
  final date = dateAsync.value ?? _dateOnly(DateTime.now());

  final jsonString = await rootBundle.loadString(
    'assets/json/quran_pages.json',
  );

  final decodedJson = json.decode(jsonString);

  if (decodedJson is! List || decodedJson.isEmpty) {
    throw const FormatException('ملف الآيات اليومية فارغ أو غير صالح.');
  }

  final seed = _createDateSeed(date);
  final index = seed % decodedJson.length;

  return Map<String, dynamic>.from(decodedJson[index] as Map);
});

/// يوفر دعاء يوميًا يتغير كل يوم بناءً على التاريخ الكامل.
final dailyDuaaProvider = FutureProvider.autoDispose<String>((ref) async {
  final dateAsync = ref.watch(dailyContentDateProvider);
  final date = dateAsync.value ?? _dateOnly(DateTime.now());

  final jsonString = await rootBundle.loadString('assets/json/daily_duas.json');

  final decodedJson = json.decode(jsonString);

  if (decodedJson is! List || decodedJson.isEmpty) {
    throw const FormatException('ملف الأدعية اليومية فارغ أو غير صالح.');
  }

  final duas = decodedJson.whereType<String>().where((duaa) {
    return duaa.trim().isNotEmpty;
  }).toList();

  if (duas.isEmpty) {
    throw const FormatException('لا توجد أدعية صالحة داخل الملف.');
  }

  final seed = _createDateSeed(date);
  final index = seed % duas.length;

  return duas[index];
});

int _createDateSeed(DateTime date) {
  return date.year * 10000 + date.month * 100 + date.day;
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
