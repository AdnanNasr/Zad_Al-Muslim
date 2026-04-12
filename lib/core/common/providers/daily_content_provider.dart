import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// يوفر آية يومية تتغير كل يوم بناءً على التاريخ
final dailyVerseProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  ref.keepAlive();

  final jsonString = await rootBundle.loadString('assets/json/quran_pages.json');
  final List<dynamic> allVerses = json.decode(jsonString);

  // اختيار آية بناءً على اليوم (seed مبني على التاريخ)
  final now = DateTime.now();
  final seed = now.year * 366 + now.month * 31 + now.day;
  final index = seed % allVerses.length;

  return Map<String, dynamic>.from(allVerses[index]);
});

/// يوفر دعاء يومي يتغير كل يوم
final dailyDuaaProvider = FutureProvider<String>((ref) async {
  ref.keepAlive();

  final jsonString =
      await rootBundle.loadString('assets/json/daily_duas.json');
  final List<dynamic> duas = json.decode(jsonString);

  final dayIndex = (DateTime.now().day - 1) % duas.length;
  return duas[dayIndex] as String;
});
