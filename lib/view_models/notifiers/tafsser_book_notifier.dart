import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/view_models/models/db/islamic/tafsser/tafsser_surah.dart';
import 'package:noor_quran/view_models/utils/app_logger.dart';

class TafsserBookNotifier extends StateNotifier<AsyncValue<EditionModel>> {
  TafsserBookNotifier(this.db)
    : super(
        AsyncValue.data(
          // التفسير الأفتراضي في التطبيق هو تفسير الجلالين
          EditionModel()
            ..name = "تفسير الجلالين"
            ..englishName = "Jalal ad-Din al-Mahalli and Jalal ad-Din as-Suyuti"
            ..language = "ar"
            ..identifier = "ar.jalalayn",
        ),
      );

  final Isar? db;

  // التأكد من أن التفسير موجود في قاعدة البيانات
  Future<bool> isTafsserExist({required String tafseerName}) async {
    final query = await db!.tafsserSurahs
        .filter()
        .edition((e) => e.nameEqualTo(tafseerName))
        .findFirst();
    if (query != null) {
      return true;
    }
    return false;
  }

  // وضع التفسير الذي اختاره المستخدم في الـ State
  Future<bool> setTafsserBook({required String tafseerName}) async {
    final checkIsTafsserExist = await isTafsserExist(tafseerName: tafseerName);
    if (checkIsTafsserExist) {
      final getEdition = await db!.tafsserSurahs
          .filter()
          .edition((e) => e.nameEqualTo(tafseerName))
          .findFirst();

      if (getEdition != null) {
        state = AsyncValue.data(getEdition.edition!);
        
        return true;
      }
    }
    AppLogger.logger.e("لم يتم العثور على كتاب التفسير في قاعدة البيانات");
    return false;
  }

  // الحصول على جميع التفاسير المتاحة في قاعدة البيانات من اجل عرضها في القائمة
  Future<Set<EditionModel>> getAllAvailableTafsserBooks() async {
    final List<EditionModel?> allNames = await db!.tafsserSurahs
        .where()
        .editionProperty()
        .findAll();

    final Set<EditionModel> books = allNames.whereType<EditionModel>().toSet();

    return books;
  }
}
