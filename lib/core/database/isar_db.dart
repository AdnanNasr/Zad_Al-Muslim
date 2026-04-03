import 'dart:io';
import 'package:isar/isar.dart';
import 'package:noor_quran/features/quran/data/models/mark.dart';
import 'package:noor_quran/features/quran/data/models/quran_models.dart';
import 'package:noor_quran/features/hadith/data/models/hadith_model.dart';
import 'package:noor_quran/features/tafsser/data/models/tafsser_surah.dart';
import 'package:noor_quran/features/tafsser/data/models/ayah.dart';
import 'package:noor_quran/features/pray_time/data/models/prayer_times_model.dart';

import 'package:noor_quran/core/utils/log/app_logger.dart';
import 'package:path_provider/path_provider.dart';

class IsarDb {
  static Isar? database;

  static Future<Isar> initDatabase() async {
    if (database != null && database!.isOpen) return database!;

    final dir = await getApplicationDocumentsDirectory();

    // ⚠️ تغيّر نوع hadithnumber من long إلى string — نمسح قاعدة البيانات القديمة
    // إذا كانت موجودة بالـ schema القديم لمنع crash عند فتحها
    await _migrateIfNeeded(dir.path);

    database = await Isar.open(
      [
        QuranPageSchema,
        MarkSchema,
        HadithSchema,
        TafsserSurahSchema,
        AyahTafsserSchema,
        PrayerTimesModelSchema,
      ],
      directory: dir.path,
    );

    // هجرة لتحديث textNormalized إذا كان فارغاً (مثلاً بعد تغيير الـ Schema)
    final count = await database!.hadiths.count();
    if (count > 0) {
      final firstHadith = await database!.hadiths.where().findFirst();
      if (firstHadith != null && firstHadith.textNormalized.isEmpty && firstHadith.text.isNotEmpty) {
        AppLogger.logger.i("🔄 جاري تحديث الأحاديث لإضافة حقل textNormalized للمقالات القديمة...");
        await database!.writeTxn(() async {
          final allHadiths = await database!.hadiths.where().findAll();
          for (var h in allHadiths) {
            h.textNormalized = h.text
                .replaceAll(RegExp(r'[\u064B-\u065F]'), '')
                .replaceAll(RegExp(r'[أإآ]'), 'ا')
                .replaceAll(RegExp(r'ة'), 'ه')
                .replaceAll(RegExp(r'ى'), 'ي');
          }
          await database!.hadiths.putAll(allHadiths);
        });
        AppLogger.logger.i("✅ تمت هجرة قاعدة بيانات الأحاديث بنجاح");
      }
    }

    AppLogger.logger.i("✅ تم تهيئة قاعدة البيانات بنجاح");
    return database!;
  }

  /// يتحقق إذا كانت قاعدة البيانات القديمة موجودة بـ schema غير متوافق
  /// عن طريق محاولة فتح قاعدة البيانات — إذا فشل يحذفها ويبدأ من جديد
  static Future<void> _migrateIfNeeded(String dirPath) async {
    try {
      final testDb = await Isar.open(
        [
          QuranPageSchema,
          MarkSchema,
          HadithSchema,
          TafsserSurahSchema,
          AyahTafsserSchema,
          PrayerTimesModelSchema,
        ],
        directory: dirPath,
        name: 'default', // الاسم الافتراضي
      );
      await testDb.close();
      AppLogger.logger.i("✅ Schema متوافق، لا يلزم Migration");
    } catch (e) {
      AppLogger.logger.w(
        "⚠️ Schema غير متوافق (ربما تغيّر نوع hadithnumber). جاري حذف قاعدة البيانات القديمة...",
      );
      // احذف ملف قاعدة البيانات
      final dbFile = File('$dirPath/default.isar');
      final dbLockFile = File('$dirPath/default.isar.lock');
      if (await dbFile.exists()) await dbFile.delete();
      if (await dbLockFile.exists()) await dbLockFile.delete();
      AppLogger.logger.i(
        "🗑️ تم حذف قاعدة البيانات القديمة. سيتم إعادة إدخال البيانات.",
      );
    }
  }
}
