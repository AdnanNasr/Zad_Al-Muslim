import 'package:flutter/foundation.dart';
import 'package:qcf_quran/qcf_quran.dart' as qcf;
import 'package:zad_al_muslim/core/constants/surah_names.dart';

class QuranSearchIndexer {
  static List<Map<String, dynamic>> cache = [];

  static bool get isReady => cache.isNotEmpty;

  static Future<void> initialize() async {
    if (cache.isNotEmpty) return;

    // We run it on a separate isolate so it doesn't block app startup
    cache = await compute(_buildQuranIndexTask, null);
  }
}

List<Map<String, dynamic>> _buildQuranIndexTask(dynamic _) {
  final List<Map<String, dynamic>> tempIndex = [];
  for (int surah = 1; surah <= 114; surah++) {
    int vCount = qcf.getVerseCount(surah);
    for (int verse = 1; verse <= vCount; verse++) {
      String rawVerse = qcf.getVerse(surah, verse, verseEndSymbol: false);
      String normal = robustNormalizeQuranText(rawVerse);
      tempIndex.add({
        'surahNumber': surah,
        'ayahNumber': verse,
        'surah': SurahNames.getFormattedName(surah),
        'ayah': verse.toString(),
        'text': rawVerse,
        'normalized': normal,
      });
    }
  }
  return tempIndex;
}

String robustNormalizeQuranText(String input) {
  String s = input.replaceAll('\u0670', 'ا'); // الألف الخنجرية
  s = s.replaceAll('\u06E5', 'و'); // الواو الصغيرة
  s = s.replaceAll('\u06E6', 'ى'); // الياء الصغيرة

  String clean = s.replaceAll(
    RegExp(r'[\u064B-\u065F\u06D6-\u06ED\u0640]'),
    '',
  );

  return clean
      .replaceAll(RegExp(r'[أإآاٱ]'), 'ا') // توحيد الألف وهمزة الوصل
      .replaceAll('ة', 'ه') // توحيد التاء المربوطة
      .replaceAll(RegExp(r'[يىئ]'), 'ى') // توحيد الياء والألف المقصورة والنبرة
      .replaceAll('ؤ', 'و')
      .replaceAll(RegExp(r'\s+'), ' ') // إزالة المسافات المزدوجة
      .trim();
}
