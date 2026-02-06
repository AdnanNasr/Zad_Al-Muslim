import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/view_models/models/db/isar_db.dart';
import 'package:noor_quran/view_models/models/db/islamic/mark.dart';
import 'package:noor_quran/view_models/utils/app_logger.dart';

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
        .findFirst();

    if (mark != null) {
      // update state
      state = state.where((m) => m.pageNumber != pageNumber).toList();

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
        .findFirst();

    return mark != null; // true = exists
  }

  Future<void> loadMarks() async {
    state = await db!.marks.where().findAll();
    AppLogger.logger.i("تم تحميل العلامات");
  }
}

final marksProvder = StateNotifierProvider<MarksProvider, List<Mark>>((ref) {
  return MarksProvider();
});


  final markExistsProvider = FutureProvider.family<bool, int>((
    ref,
    page,
  ) async {
    final notifier = ref.read(marksProvder.notifier);
    return notifier.exists(page);
  });
