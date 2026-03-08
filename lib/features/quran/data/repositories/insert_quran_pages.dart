import 'dart:convert';
import 'package:noor_quran/core/database/isar_db.dart';
import 'package:noor_quran/features/quran/data/models/quran_models.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:noor_quran/core/utils/log/app_logger.dart';

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
    // 1. قراءة البيانات
    final content = await rootBundle.loadString('assets/json/quran_pages.json');
    final List<dynamic> allAyahs = jsonDecode(content);

    AppLogger.logger.w("جاري معالجة وتجميع الصفحات...");

    // 2. تجميع الآيات حسب رقم الصفحة في Map
    // Key: رقم الصفحة، Value: قائمة الآيات التابعة لها
    Map<int, List<Ayah>> pagesMap = {};

    for (var a in allAyahs) {
      int pageNum = a['page'];
      final originalText = a['aya_text'] ?? '';

      final ayahObj = Ayah()
        ..surahNumber = a['sura_no'] ?? 0
        ..surahName = a['sura_name_ar'] ?? ''
        ..ayahNumber = a['aya_no'] ?? 0
        ..ayaTextEmlaey = normalizeArabicText(a['aya_text_emlaey'])
        ..text = originalText;

      if (!pagesMap.containsKey(pageNum)) {
        pagesMap[pageNum] = [];
      }
      pagesMap[pageNum]!.add(ayahObj);
    }

    // 3. إدخال البيانات إلى Isar
    await isar.writeTxn(() async {
      await isar.quranPages.clear(); // مسح القديم للتأكد من النظافة

      for (var entry in pagesMap.entries) {
        final pageObj = QuranPage()
          ..pageNumber = entry.key
          ..ayahs = entry.value;

        await isar.quranPages.put(pageObj);
      }
    });

    AppLogger.logger.i("✅ تم إدخال 604 صفحة بنجاح");
  }
}
