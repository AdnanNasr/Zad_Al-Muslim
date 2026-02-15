import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/view_models/models/db/islamic/tafsser/ayah.dart';
import 'package:noor_quran/view_models/models/db/islamic/tafsser/tafsser_surah.dart';
import 'package:noor_quran/view_models/utils/app_logger.dart';

class TafsserNoifier extends StateNotifier<AsyncValue<AyahTafsser>> {
  TafsserNoifier(this.db) : super(const AsyncValue.loading());
  final Isar? db;

  // ------------- CRUD ----------------

  // get spicfic tafsser
  Future<AyahTafsser?> getTafsserByAyahNumber({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    try {
      // البحث مباشرة في جدول الآيات مع تصفية بناءً على رقم السورة ورقم الآية
      final result = await db!.ayahTafssers
          .filter()
          .surah((s) => s.numberEqualTo(surahNumber))
          .and()
          .numberInSurahEqualTo(ayahNumber)
          .findFirst();

      return result;
    } catch (e, stack) {
      // تسجيل الخطأ إذا وجد
      AppLogger.logger.e("Error: $e | $stack");
      return null;
    }
  }

  // }

  // get holy tafsser

  // get tafsser by name
}
