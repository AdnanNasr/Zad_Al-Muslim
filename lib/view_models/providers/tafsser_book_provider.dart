import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/view_models/models/db/isar_db.dart';
import 'package:noor_quran/view_models/models/db/islamic/tafsser/tafsser_surah.dart';
import 'package:noor_quran/view_models/notifiers/tafsser_book_notifier.dart';

final tafsserBookProvider =
    StateNotifierProvider<TafsserBookNotifier, AsyncValue<EditionModel>>((ref) {
      final db = IsarDb.database;
      return TafsserBookNotifier(db);
    });
