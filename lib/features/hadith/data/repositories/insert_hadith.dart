import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:isar_community/isar.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';
import 'package:zad_al_muslim/features/hadith/data/models/hadith_model.dart';
import 'package:zad_al_muslim/features/hadith/data/models/reference_model.dart';

Future<void> insertHadithToIsar() async {
  final db = sl<Isar>();

  try {
    AppLogger.logger.i("📖 بدء عملية إدخال الأحاديث إلى قاعدة البيانات...");

    // فحص إذا كانت الأحاديث مدخلة مسبقاً
    final existingCount = await db.hadiths.count();
    if (existingCount > 0) {
      AppLogger.logger.w(
        "⚠️ قاعدة البيانات تحتوي مسبقاً على $existingCount حديث. لن يتم الإدخال مجدداً.",
      );
      return;
    }

    AppLogger.logger.i("📂 جاري تحميل ملف ar_bukhari.json من الـ assets...");
    final content = await rootBundle.loadString("assets/json/ar_bukhari.json");
    AppLogger.logger.i("✅ تم تحميل الملف بنجاح. جاري فك ترميز JSON...");

    final data = jsonDecode(content) as Map<String, dynamic>;
    AppLogger.logger.i("🔑 المفاتيح الرئيسية في JSON: ${data.keys.toList()}");

    // ⚠️ المشكلة كانت هنا: الأحاديث في data["hadiths"] وليس في data["metadata"]["hadiths"]
    final hadithData = data["hadiths"] as List?;

    if (hadithData == null || hadithData.isEmpty) {
      AppLogger.logger.e(
        "❌ لم يتم العثور على أحاديث في ملف JSON! "
        "تأكد من أن المفتاح هو 'hadiths' وليس 'metadata.hadiths'",
      );
      AppLogger.logger.e(
        "🔑 المفاتيح الموجودة في الـ JSON: ${data.keys.toList()}",
      );
      return;
    }

    AppLogger.logger.i(
      "📊 تم العثور على ${hadithData.length} حديث. جاري الإدخال...",
    );

    // استخدام transaction واحدة لتحسين الأداء بشكل كبير
    await db.writeTxn(() async {
      final hadiths = <Hadith>[];

      for (int i = 0; i < hadithData.length; i++) {
        final h = hadithData[i] as Map<String, dynamic>;

        // فحص الحقول المطلوبة
        final hadithnumber = h["hadithnumber"];
        final text = h["text"];
        final referenceRaw = h["reference"] as Map<String, dynamic>?;

        if (hadithnumber == null || text == null) {
          AppLogger.logger.w(
            "⚠️ حديث ناقص عند الفهرس $i: hadithnumber=$hadithnumber",
          );
          continue;
        }

        final hadithObj = Hadith()
          ..hadithnumber = hadithnumber.toString()
          ..text = text.toString()
          ..reference = ReferenceModel(
            book: referenceRaw?["book"] as int?,
            hadith: referenceRaw?["hadith"] as int?,
          )
          ..textNormalized = normlizeHadithText(text);
        hadiths.add(hadithObj);
      }

      AppLogger.logger.i(
        "💾 جاري كتابة ${hadiths.length} حديث في transaction واحدة...",
      );
      await db.hadiths.putAll(hadiths);
    });

    final finalCount = await db.hadiths.count();
    AppLogger.logger.i(
      "✅ تم إدخال الأحاديث إلى قاعدة البيانات بنجاح! "
      "إجمالي الأحاديث المحفوظة: $finalCount",
    );
  } catch (e, stackTrace) {
    AppLogger.logger.e(
      "❌ فشل إدخال الأحاديث إلى قاعدة البيانات.",
      error: e,
      stackTrace: stackTrace,
    );
  }
}

String normlizeHadithText(String text) {
  return text
      .replaceAll(RegExp(r'[\u064B-\u065F]'), '')
      .replaceAll(RegExp(r'[أإآ]'), 'ا')
      .replaceAll(RegExp(r'ة'), 'ه')
      .replaceAll(RegExp(r'ى'), 'ي');
}
