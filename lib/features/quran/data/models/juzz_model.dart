import 'package:noor_quran/features/quran/data/models/verses_model.dart';
import 'package:noor_quran/features/quran/domain/entities/juzz_entity.dart';

class JuzzModel extends JuzzEntity {
  JuzzModel({
    required super.id,
    required super.surahs,
    required super.versesEntity,
  });

  JuzzEntity toEntity() {
    return JuzzEntity(id: id, surahs: surahs, versesEntity: versesEntity);
  }

  factory JuzzModel.fromEntity(JuzzEntity entity) {
    return JuzzModel(
      id: entity.id,
      surahs: entity.surahs,
      versesEntity: entity.versesEntity,
    );
  }

  factory JuzzModel.fromMap(Map<String, dynamic> map) {
    return JuzzModel(
      id: map["id"],
      surahs: map["surahs"],
      versesEntity: VersesModel.fromMap(map["verses"]),
    );
  }
}
