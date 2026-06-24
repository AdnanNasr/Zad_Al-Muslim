import 'package:isar_community/isar.dart';
import 'package:zad_al_muslim/features/hadith/data/models/reference_model.dart';
import '../models/hadith_model.dart';
import '../../domain/entities/hadith_entity.dart';

abstract class HadithLocalDataSource {
  Future<List<HadithEntity>> getHadiths(HadithFiltersEntity filters);
  Future<HadithEntity> saveHadith(HadithEntity hadith);
  Future<void> deleteHadith(int id);
}

class HadithLocalDataSourceImpl implements HadithLocalDataSource {
  final Isar isar;

  HadithLocalDataSourceImpl(this.isar);

  @override
  Future<void> deleteHadith(int id) async {
    await isar.writeTxn(() async {
      await isar.hadiths.delete(id);
    });
  }

  @override
  Future<List<HadithEntity>> getHadiths(HadithFiltersEntity filters) async {
    final words = filters.searchQuery?.split(' ') ?? [];
    final cleanWords = words
        .map((w) => w.trim())
        .where((w) => w.isNotEmpty)
        .toList();

    final result = await isar.hadiths
        .filter()
        .optional(filters.favoritesOnly, (q) => q.isFavoriteEqualTo(true))
        .optional(
          filters.bookNumber != null,
          (q) => q.reference((r) => r.bookEqualTo(filters.bookNumber!)),
        )
        .optional(
          cleanWords.isNotEmpty,
          (q) => q.allOf(cleanWords, (q, word) {
            final normalizedWord = word
                .replaceAll(RegExp(r'[\u064B-\u065F]'), '')
                .replaceAll(RegExp(r'[أإآ]'), 'ا')
                .replaceAll(RegExp(r'ة'), 'ه')
                .replaceAll(RegExp(r'ى'), 'ي');
            return q.textNormalizedContains(normalizedWord);
          }),
        )
        .offset(filters.offset)
        .limit(filters.limit)
        .findAll();

    return result.map((h) => h.toEntity()).toList();
  }

  @override
  Future<HadithEntity> saveHadith(HadithEntity hadith) async {
    final model = Hadith.fromEntity(hadith);
    await isar.writeTxn(() async {
      await isar.hadiths.put(model);
    });
    return model.toEntity();
  }
}
