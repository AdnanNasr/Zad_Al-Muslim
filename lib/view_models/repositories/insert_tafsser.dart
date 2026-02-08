import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:isar/isar.dart';
import 'package:noor_quran/view_models/models/db/isar_db.dart';
import 'package:noor_quran/view_models/models/db/islamic/surah.dart'; // تأكد من وجود موديل AyahModel هنا أو استيراده
import 'package:noor_quran/view_models/utils/app_logger.dart';

Future<void> insertTafsserToIsar({
  required Map<String, dynamic> jsonMap,
}) async {
  final isar = IsarDb.database;

  // التحقق من أن قاعدة البيانات مهيأة
  if (isar == null) {
    AppLogger.logger.e("قاعدة البيانات Isar غير مهيأة! ❌");
    return;
  }

  try {
    final editionData =
        (jsonMap["data"]?["edition"] as Map<String, dynamic>? ?? {});
    final surahsData = (jsonMap['data']?['surahs'] as List?) ?? [];
    
    // استخراج المعرف الفريد للتفسير (مثل ar.jalalayn)
    final String? currentIdentifier = editionData["identifier"];

    if (currentIdentifier == null || currentIdentifier.isEmpty) {
      AppLogger.logger.e("فشل الإدخال: معرف التفسير (identifier) غير موجود في الـ JSON ❌");
      return;
    }

    AppLogger.logger.w("🚀 جاري تحضير قاعدة البيانات لإدخال تفسير: $currentIdentifier");

    // بدء عملية Transaction واحدة لضمان السرعة وسلامة البيانات
    await isar.writeTxn(() async {
      
      // --- تعديل الأمان: التنظيف الذاتي ---
      // حذف أي بيانات قديمة مرتبطة بهذا التفسير (في حال كان التحميل سابقاً غير مكتمل)
      // نبدأ بحذف الآيات أولاً ثم السور لتجنب البيانات اليتيمة
      await isar.ayahModels
          .filter()
          .surah((q) => q.edition((e) => e.identifierEqualTo(currentIdentifier)))
          .deleteAll();

      await isar.surahs
          .filter()
          .edition((e) => e.identifierEqualTo(currentIdentifier))
          .deleteAll();

      AppLogger.logger.i("🧹 تم تنظيف البيانات السابقة لضمان عدم التكرار.");

      // --- عملية الإدخال الجديدة ---
      for (final s in surahsData) {
        // 1. إنشاء كائن السورة مع الـ Edition (Embedded Object)
        final surahObj = Surah()
          ..number = s["number"]
          ..name = s["name"]
          ..englishName = s["englishName"]
          ..englishNameTranslation = s["englishNameTranslation"]
          ..revelationType = s["revelationType"]
          ..edition = (EditionModel()
            ..identifier = editionData["identifier"]
            ..language = editionData["language"]
            ..name = editionData["name"]
            ..englishName = editionData["englishName"]);

        // 2. حفظ السورة ليصبح لها ID متاح للربط
        await isar.surahs.put(surahObj);

        final ayahMaps = (s["ayahs"] as List?) ?? [];
        final ayahObjs = <AyahModel>[];

        for (final ayah in ayahMaps) {
          final ay = AyahModel()
            ..number = ayah["number"]
            ..text = ayah["text"]
            ..numberInSurah = ayah["numberInSurah"];

          // 3. ربط الآية بالسورة (IsarLink)
          ay.surah.value = surahObj;
          ayahObjs.add(ay);
        }

        if (ayahObjs.isNotEmpty) {
          // 4. حفظ جميع الآيات دفعة واحدة لرفع الأداء
          await isar.ayahModels.putAll(ayahObjs);

          // 5. تحديث الـ Backlink في طرف السورة (IsarLinks)
          surahObj.ayahs.addAll(ayahObjs);
          
          // 6. حفظ الروابط فعلياً في قاعدة البيانات
          await surahObj.ayahs.save();
        }
      }
    });

    AppLogger.logger.i("🎊 تم الانتهاء من إدخال تفسير ($currentIdentifier) بنجاح!");
  } catch (e, stack) {
    AppLogger.logger.e("حدث خطأ غير متوقع أثناء إدخال البيانات: $e");
    debugPrint(stack.toString()); 
  }
}

Future<void> loadTafsserFromAssest() async {
  final isar = IsarDb.database;

  if (isar != null) {
    // 1. استخدام الاستعلام المباشر لعد السور التي تنتمي للجلالين فقط
    final jalalaynCount = await isar.surahs
        .filter()
        .edition((q) => q.identifierEqualTo("ar.jalalayn"))
        .count();

    // 2. إذا كان العدد أقل من 114، نقوم بالإدخال
    if (jalalaynCount < 114) {
      AppLogger.logger.i("تفسير الجلالين غير مكتمل، جاري التحميل من Assets...");
      
      final content = await rootBundle.loadString(
        'assets/json/quran_ar_jalalayn.json',
      );
      final jsonMap = jsonDecode(content) as Map<String, dynamic>;
      
      // ملاحظة: تأكد أن دالة insertTafsserToIsar تحتوي على txn.deleteAll() 
      // لنفس المعرف قبل البدء لتجنب أي تكرار للبيانات الناقصة
      await insertTafsserToIsar(jsonMap: jsonMap);
    } else {
      AppLogger.logger.i("تفسير الجلالين موجود بالفعل، لن يتم إعادة التحميل.");
    }
  }
}
