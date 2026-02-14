import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/view_models/models/db/islamic/tafsser/tafsser_surah.dart';

class TafsserProvider extends StateNotifier<List<TafsserSurah>>{
  TafsserProvider(this.db) : super ([]);
  final Isar? db;

  // ------------- CRUD ----------------

  // get spicfic tafsser
  // Future<TafsserSurah> getTafsserByAyahNumber({required int surahNumber, required int ayahNumber}) async {
    
  // }

  // get holy tafsser

  // get tafsser by name

}