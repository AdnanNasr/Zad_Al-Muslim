import 'package:isar/isar.dart';
import '../models/hadith.dart';
import '../../domain/entities/hadith_entity.dart';

abstract class HadithLocalDataSource {
  Future<List<Hadith>> getHadiths(HadithFiltersEntity filters);
  Future<Hadith> saveHadith(Hadith hadith);
  Future<void> deleteHadith(int id);
}

class HadithLocalDataSourceImpl implements HadithLocalDataSource {
  final Isar isar;

  HadithLocalDataSourceImpl(this.isar);

  @override
  Future<List<Hadith>> getHadiths(HadithFiltersEntity filters) async {
    QueryBuilder<Hadith, Hadith, QAfterFilterCondition> query = 
        isar.hadiths.filter().idGreaterThan(-1);

    if (filters.book != null) {
      query = query.and().bookEqualTo(filters.book!);
    }
    if (filters.narrator != null) {
      query = query.and().hadithNarratorEqualTo(filters.narrator!);
    }
    if (filters.topic != null) {
      query = query.and().topicEqualTo(filters.topic!);
    }
    if (filters.grade != null) {
      query = query.and().gradeEqualTo(filters.grade!);
    }
    if (filters.featuredOnly) {
      query = query.and().isFeaturedEqualTo(true);
    }

    return await query.findAll();
  }

  @override
  Future<Hadith> saveHadith(Hadith hadith) async {
    await isar.writeTxn(() async {
      await isar.hadiths.put(hadith);
    });
    return hadith;
  }

  @override
  Future<void> deleteHadith(int id) async {
    await isar.writeTxn(() async {
      await isar.hadiths.delete(id);
    });
  }
}
