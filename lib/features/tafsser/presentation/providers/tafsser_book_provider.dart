import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/database/isar_db.dart';
import 'package:noor_quran/features/tafsser/data/models/tafsser_surah.dart';
import 'package:noor_quran/features/tafsser/domain/usecases/tafsser_book_notifier.dart';

final tafsserBookProvider =
    StateNotifierProvider<TafsserBookNotifier, AsyncValue<EditionModel>>((ref) {
      final db = IsarDb.database;
      return TafsserBookNotifier(db);
    });
