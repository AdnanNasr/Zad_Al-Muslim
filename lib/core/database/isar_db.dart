import 'package:isar_community/isar.dart';
import 'package:zad_al_muslim/features/adkar/data/models/adkar_model.dart';
import 'package:zad_al_muslim/features/adkar/data/models/dhikr_state_model.dart';
import 'package:zad_al_muslim/features/quran/data/models/mark.dart';
import 'package:zad_al_muslim/features/quran/data/models/quran_models.dart';
import 'package:zad_al_muslim/features/hadith/data/models/hadith_model.dart';
import 'package:zad_al_muslim/features/tafsser/data/models/tafsser_surah.dart';
import 'package:zad_al_muslim/features/tafsser/data/models/ayah.dart';
import 'package:zad_al_muslim/features/pray_time/data/models/prayer_adjustments_model.dart';
import 'package:zad_al_muslim/infrastructure/models/prayer_time_entity.dart';

import 'package:zad_al_muslim/core/utils/log/app_logger.dart';
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
      AyahTafsserSchema,
      PrayerAdjustmentsModelSchema,
      AdkarModelSchema,
      PrayerTimeEntitySchema,
      DhikrStateModelSchema,
    ], directory: dir.path);
    AppLogger.logger.i("✅ تم تهيئة قاعدة البيانات بنجاح");
    return database!;
  }
}
