import 'package:isar/isar.dart';
import 'package:noor_quran/core/constants/enums/my_enums.dart';
import '../../domain/entities/hadith_entity.dart';

part 'hadith.g.dart';

@collection
class Hadith {
  Id id = Isar.autoIncrement;

  late String hadith;
  late String hadithNarrator;
  late bool isFeatured;
  late String topic;
  
  @enumerated
  late HadithGrade grade;

  late String book;

  HadithEntity toEntity() {
    return HadithEntity(
      id: id,
      hadith: hadith,
      hadithNarrator: hadithNarrator,
      isFeatured: isFeatured,
      topic: topic,
      grade: grade,
      book: book,
    );
  }

  static Hadith fromEntity(HadithEntity entity) {
    return Hadith()
      ..id = entity.id
      ..hadith = entity.hadith
      ..hadithNarrator = entity.hadithNarrator
      ..isFeatured = entity.isFeatured
      ..topic = entity.topic
      ..grade = entity.grade
      ..book = entity.book;
  }
}

