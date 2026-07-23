import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:isar_community/isar.dart';
import 'package:zad_al_muslim/core/database/isar_db.dart';
import 'package:zad_al_muslim/features/quran/data/models/mark.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';

class MarksProvider extends StateNotifier<List<Mark>> {
  MarksProvider() : super([]);

  final db = IsarDb.database;

  // add mark
  Future<void> addMark(Mark mark) async {
    // add to state
    state = [...state, mark];

    // add to db
    await db?.writeTxn(() async {
      await db!.marks.put(mark);
    });
  }

  // remove mark
  Future<void> removeMark(int pageNumber) async {
    final mark = await db?.marks
        .filter()
        .pageNumberEqualTo(pageNumber)
        .ayahNumberIsNull()
        .findFirst();

    if (mark != null) {
      // update state
      state = state.where((m) => m.id != mark.id).toList();

      // delete from db
      await db?.writeTxn(() async {
        await db!.marks.delete(mark.id);
      });
    }
  }

  // check if mark exists
  Future<bool> exists(int pageNumber) async {
    final mark = await db?.marks
        .filter()
        .pageNumberEqualTo(pageNumber)
        .ayahNumberIsNull()
        .findFirst();

    return mark != null; // true = exists
  }

  // remove ayah mark
  Future<void> removeAyahMark(int surahNumber, int ayahNumber) async {
    final list = await db?.marks
        .filter()
        .surahNumberEqualTo(surahNumber)
        .ayahNumberEqualTo(ayahNumber)
        .findAll();

    if (list != null && list.isNotEmpty) {
      final mark = list.first;
      state = state.where((m) => m.id != mark.id).toList();

      await db?.writeTxn(() async {
        await db!.marks.delete(mark.id);
      });
    }
  }

  // check if ayah mark exists
  Future<bool> existsAyah(int surahNumber, int ayahNumber) async {
    final mark = await db?.marks
        .filter()
        .surahNumberEqualTo(surahNumber)
        .ayahNumberEqualTo(ayahNumber)
        .findFirst();

    return mark != null;
  }

  Future<void> loadMarks() async {
    state = await db!.marks.where().findAll();
    AppLogger.logger.i("تم تحميل العلامات");
  }
}

final marksProvder = StateNotifierProvider<MarksProvider, List<Mark>>((ref) {
  return MarksProvider();
});

/// مصدر الحقيقة الوحيد لموضع متابعة القراءة في الصفحة الرئيسية.
/// نستبعد علامات الآيات ونختار أحدث علامة صالحة زمنيًا.
final latestReadingMarkProvider = Provider<Mark?>((ref) {
  final marks = ref.watch(marksProvder);
  Mark? latest;

  for (final mark in marks) {
    final isValidPage = mark.pageNumber >= 1 && mark.pageNumber <= 604;
    if (mark.ayahNumber != null || !isValidPage) continue;

    if (latest == null || mark.date.isAfter(latest.date)) {
      latest = mark;
    }
  }

  return latest;
});

final markExistsProvider = FutureProvider.family<bool, int>((ref, page) async {
  final notifier = ref.read(marksProvder.notifier);
  return notifier.exists(page);
});
