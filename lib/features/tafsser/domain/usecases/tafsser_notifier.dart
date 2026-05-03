import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:zad_al_muslim/features/tafsser/data/models/ayah.dart';
import 'package:zad_al_muslim/features/tafsser/data/models/tafsser_surah.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';

class TafsserNoifier extends StateNotifier<AsyncValue<AyahTafsser>> {
  TafsserNoifier(this.db) : super(const AsyncValue.loading());
  final Isar? db;

  // ------------- CRUD ----------------

  // get spicfic tafsser
  Future<AyahTafsser?> getTafsserByAyahNumber({
  required int surahNumber,
  required int ayahNumber,
  required EditionModel edition,
}) async {
  try {
    // 1. نبحث عن السورة التي تحقق الشرطين: رقم السورة واسم التفسير
    final TafsserSurah? surah = await db!.tafsserSurahs
        .filter()
        .numberEqualTo(surahNumber)
        .and()
        .edition((e) => e.nameEqualTo(edition.name))
        .findFirst();

    if (surah == null) return null;

    // 2. بما أن الآيات هي IsarLinks، يجب تحميلها أولاً (Load)
    if (!surah.ayahs.isLoaded) {
      await surah.ayahs.load();
    }

    // 3. الآن نبحث عن الآية المطلوبة داخل الروابط المحملة
    // نستخدم Dart هنا لأن التصفية على الـ Links بعد تحميلها تكون في الذاكرة
    try {
      return surah.ayahs.firstWhere(
        (a) => a.numberInSurah == ayahNumber,
      );
    } catch (e) {
      AppLogger.logger.e("لم يتم العثور على الآية المطلوبة\nرمز الخطأ: $e");
      return null; // في حال لم يجد رقم الآية
    }

  } catch (e, stack) {
    AppLogger.logger.e("Error: $e | $stack");
    return null;
  }
}

  // get holy tafsser

  // get tafsser by name
}
