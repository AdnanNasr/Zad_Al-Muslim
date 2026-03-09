import 'package:isar/isar.dart';
import "package:noor_quran/features/tafsser/data/models/ayah.dart";
import '../../domain/entities/tafsser_entities.dart';

part 'tafsser_surah.g.dart';

@collection
class TafsserSurah {
  Id id = Isar.autoIncrement;

  late int number;
  late String name;
  late String englishName;
  late String englishNameTranslation;
  late String revelationType;

  @Backlink(to: 'surah')
  final ayahs = IsarLinks<AyahTafsser>();

  // embedded edition, optional
  EditionModel? edition;

  TafsserBookEntity toBookEntity(bool isDownloaded) {
    return TafsserBookEntity(
      id: edition?.identifier ?? '',
      name: edition?.name ?? name,
      description: edition?.englishName ?? englishName,
      isDownloaded: isDownloaded,
    );
  }
}

@embedded
class EditionModel {
  String? identifier;
  String? language;
  String? name;
  String? englishName;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditionModel &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
