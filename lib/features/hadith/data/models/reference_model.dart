import 'package:isar/isar.dart';
import 'package:noor_quran/features/hadith/domain/entities/hadith_entity.dart';

part 'reference_model.g.dart';

@embedded
class ReferenceModel {
  int? book;
  int? hadith;

  ReferenceModel({this.book, this.hadith});

  factory ReferenceModel.fromEntity(Reference reference) {
    return ReferenceModel(book: reference.book, hadith: reference.hadith);
  }
}
