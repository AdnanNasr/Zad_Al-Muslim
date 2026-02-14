import 'package:isar/isar.dart';
import 'package:noor_quran/view_models/models/db/islamic/mark.dart';
import 'package:noor_quran/view_models/models/db/islamic/quran_models.dart';
import 'package:noor_quran/view_models/models/db/islamic/hadith.dart';
import 'package:noor_quran/view_models/models/db/islamic/tafsser/tafsser_surah.dart';
import 'package:noor_quran/view_models/models/db/islamic/tafsser/ayah.dart';

import 'package:noor_quran/view_models/utils/app_logger.dart';
import 'package:path_provider/path_provider.dart';

class IsarDb {
  static Isar? database;

  static Future<Isar> initDatabase() async {
    if (database != null && database!.isOpen) return database!;

    final dir = await getApplicationDocumentsDirectory();
    database = await Isar.open([
      QuranPageSchema,
      MarkSchema,
      HadithSchema,
      TafsserSurahSchema,
      AyahTafsserSchema
    ], directory: dir.path);
    AppLogger.logger.i("تم تهيئة قاعدة البيانات بنجاح");
    return database!;
  }
}
