import 'dart:convert';
import 'package:noor_quran/view_models/models/db/isar_db.dart';
import 'package:noor_quran/view_models/models/db/islamic/quran_models.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:noor_quran/view_models/utils/app_logger.dart';

String normalizeArabicText(String text) {
  String normalized = text.replaceAll(
    RegExp(r'[\u064B-\u065F\u0670\u0640\u08F0-\u08F2]'),
    '',
  );

  normalized = normalized.replaceAll(RegExp(r'[أإآ]'), 'ا');

  normalized = normalized.replaceAll('ى', 'ي');

  normalized = normalized.replaceAll('ة', 'ه');

  normalized = normalized.replaceAll('ٱ', 'ا');

  return normalized;
}

Future<void> insertQuranPagesToIsar() async {
  final isar = IsarDb.database;

  if (await isar!.quranPages.count() < 604) {
    await isar.writeTxn(() async {
      await isar.quranPages.clear();
    });

    final content = await rootBundle.loadString('assets/json/quran_pages.json');
    final data = jsonDecode(content) as List;

    AppLogger.logger.w("جاري ادخال البيانات الى قاعدة البيانات");

    await isar.writeTxn(() async {
      for (final page in data) {
        final pageObj = QuranPage()
          ..pageNumber = page['page']
          ..ayahs = (page['ayahs'] as List).map((a) {
            final originalText = a['text'] ?? '';

            return Ayah()
              ..number = a['number'] ?? 0
              ..surahNumber = a['surah_number'] ?? 0
              ..surahName = a['surah_name'] ?? ''
              ..ayahNumber = a['ayah_number'] ?? 0
              ..revelationType = a['revelation_type'] ?? ''
              ..numberOfAyahs = a['number_of_ayahs'] ?? 0
              ..text = originalText
              ..textNormalized = normalizeArabicText(originalText);
          }).toList();

        await isar.quranPages.put(pageObj);
      }
    });

    AppLogger.logger.i("✅ تم إدخال جميع الصفحات إلى قاعدة البيانات بنجاح");
  } else {
    AppLogger.logger.d("لا داعي لجلب البيانات لانها محفوظة في الجهاز من قبل");
  }
}
