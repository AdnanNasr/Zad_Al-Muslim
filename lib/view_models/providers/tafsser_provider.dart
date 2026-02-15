import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/view_models/models/db/isar_db.dart';
import 'package:noor_quran/view_models/models/db/islamic/tafsser/ayah.dart';
import 'package:noor_quran/view_models/notifiers/tafsser_notifier.dart';

final tafsserProvider =
    StateNotifierProvider<TafsserNoifier, AsyncValue<AyahTafsser>>((ref) {
      final db = IsarDb.database;
      return TafsserNoifier(db);
    });
