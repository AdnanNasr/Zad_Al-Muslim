import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/features/hadith/data/models/hadith_model.dart';
import 'package:noor_quran/features/hadith/domain/entities/hadith_entity.dart';

final favoritesProvider = StreamProvider<List<HadithEntity>>((ref) {
  final isar = sl<Isar>();
  return isar.hadiths
      .filter()
      .isFavoriteEqualTo(true)
      .watch(fireImmediately: true)
      .map((models) => models.map((m) => m.toEntity()).toList());
});
