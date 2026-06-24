import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/features/hadith/data/models/hadith_model.dart';
import 'package:zad_al_muslim/features/hadith/domain/entities/hadith_entity.dart';

final favoritesProvider = StreamProvider<List<HadithEntity>>((ref) {
  final isar = sl<Isar>();
  return isar.hadiths
      .filter()
      .isFavoriteEqualTo(true)
      .watch(fireImmediately: true)
      .map((models) => models.map((m) => m.toEntity()).toList());
});
