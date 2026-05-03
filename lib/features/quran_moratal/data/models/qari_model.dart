import 'package:zad_al_muslim/features/quran_moratal/domain/entities/qari_entity.dart';

class QariModel extends QariEntity {
  QariModel({
    required super.name,
    required super.username,
    required super.narration,
    super.image,
  });

  factory QariModel.fromEntity(QariEntity qariEntity) {
    return QariModel(
      name: qariEntity.name,
      username: qariEntity.username,
      narration: qariEntity.narration,
      image: qariEntity.image,
    );
  }

  factory QariModel.fromJson(Map<String, dynamic> json) {
    return QariModel(
      name: json["name"],
      username: json["username"],
      narration: json["narration"],
    );
  }
}
