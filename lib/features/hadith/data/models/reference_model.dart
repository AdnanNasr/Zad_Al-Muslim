import 'package:isar_community/isar.dart';
import 'package:zad_al_muslim/features/hadith/domain/entities/hadith_entity.dart';

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
