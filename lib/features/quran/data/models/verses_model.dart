import 'package:zad_al_muslim/features/quran/domain/entities/juzz_entity.dart';

class VersesModel extends VersesEntity {
  VersesModel({required super.verses});

  VersesEntity toEntity() {
    return VersesEntity(verses: verses);
  }

  factory VersesModel.fromEntity(VersesEntity entity) {
    return VersesModel(verses: entity.verses);
  }

  factory VersesModel.fromMap(Map<int, List<int>> map) {
    return VersesModel(verses: map);
  }
}
