import 'package:isar_community/isar.dart';

import '../../../../core/database/isar_db.dart';
import '../models/ayah.dart';
import '../models/tafsser_surah.dart';
import '../repositories/insert_tafsser.dart';

abstract class TafsserLocalDataSource {
  Future<AyahTafsser?> getAyahTafsser({
    required String tafsserId,
    required int surahNumber,
    required int ayahNumber,
  });

  Future<void> saveTafsserJson(dynamic jsonMap);

  Future<bool> isTafsserDownloaded(String identifier);

  Future<void> deleteTafsser(String identifier);
}

class TafsserLocalDataSourceImpl implements TafsserLocalDataSource {
  final Isar? isar = IsarDb.database;

  @override
  Future<AyahTafsser?> getAyahTafsser({
    required String tafsserId,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    if (isar == null) return null;

    final surah = await isar!.tafsserSurahs
        .filter()
        .numberEqualTo(surahNumber)
        .and()
        .edition((e) => e.identifierEqualTo(tafsserId))
        .findFirst();

    if (surah == null) return null;

    if (!surah.ayahs.isLoaded) {
      await surah.ayahs.load();
    }

    try {
      return surah.ayahs.firstWhere((a) => a.numberInSurah == ayahNumber);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveTafsserJson(dynamic jsonMap) async {
    await insertTafsserToIsar(jsonMap: jsonMap);
  }

  @override
  Future<bool> isTafsserDownloaded(String identifier) async {
    if (isar == null) return false;
    final count = await isar!.tafsserSurahs
        .filter()
        .edition((q) => q.identifierEqualTo(identifier))
        .count();
    return count > 0;
  }

  @override
  Future<void> deleteTafsser(String identifier) async {
    if (isar == null) return;
    await isar!.writeTxn(() async {
      await isar!.ayahTafssers
          .filter()
          .surah((q) => q.edition((e) => e.identifierEqualTo(identifier)))
          .deleteAll();
      await isar!.tafsserSurahs
          .filter()
          .edition((q) => q.identifierEqualTo(identifier))
          .deleteAll();
    });
  }
}
