import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/database/isar_db.dart';
import 'package:noor_quran/features/tafsser/data/models/ayah.dart';
import 'package:noor_quran/features/tafsser/domain/usecases/tafsser_notifier.dart';

final tafsserProvider =
    StateNotifierProvider<TafsserNoifier, AsyncValue<AyahTafsser>>((ref) {
      final db = IsarDb.database;
      return TafsserNoifier(db);
    });
