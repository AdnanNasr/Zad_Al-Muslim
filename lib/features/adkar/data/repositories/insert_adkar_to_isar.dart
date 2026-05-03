import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:isar/isar.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';
import 'package:zad_al_muslim/features/adkar/data/models/adkar_model.dart';

Future<void> insertAdkarToIsar() async {
  final db = sl<Isar>();

  try {
    AppLogger.logger.i("📖 بدء عملية إدخال الأذكار إلى قاعدة البيانات...");

    // فحص إذا كانت الأذكار مدخلة مسبقاً
    final existingCount = await db.adkarModels.count();
    if (existingCount > 0) {
      AppLogger.logger.w(
        "⚠️ قاعدة البيانات تحتوي مسبقاً على $existingCount ذكر. لن يتم الإدخال مجدداً.",
      );
      return;
    }

    AppLogger.logger.i("📂 جاري تحميل ملف hisn_almuslim.json من الـ assets...");
    final content = await rootBundle.loadString(
      "assets/json/hisn_almuslim.json",
    );
    AppLogger.logger.i("✅ تم تحميل الملف بنجاح. جاري فك ترميز JSON...");

    final data = jsonDecode(content) as Map<String, dynamic>;
    AppLogger.logger.i("🔑 المفاتيح الرئيسية في JSON: ${data.keys.toList()}");

    // تحويل البيانات باستخدام دالة fromJsonList الموجودة في AdkarModel
    final adkarList = AdkarModel.fromJsonList(data);

    if (adkarList.isEmpty) {
      AppLogger.logger.e("❌ لم يتم العثور على أذكار في ملف JSON!");
      return;
    }

    AppLogger.logger.i(
      "📊 تم العثور على ${adkarList.length} تصنيف للأذكار. جاري الإدخال...",
    );

    // استخدام transaction واحدة لتحسين الأداء
    await db.writeTxn(() async {
      AppLogger.logger.i("💾 جاري كتابة الأذكار في transaction واحدة...");
      await db.adkarModels.putAll(adkarList);
    });

    final finalCount = await db.adkarModels.count();
    AppLogger.logger.i(
      "✅ تم إدخال الأذكار إلى قاعدة البيانات بنجاح! إجمالي الأنواع المحفوظة: $finalCount",
    );
  } catch (e, stackTrace) {
    AppLogger.logger.e(
      "❌ فشل إدخال الأذكار إلى قاعدة البيانات.",
      error: e,
      stackTrace: stackTrace,
    );
  }
}
