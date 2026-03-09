class AyahTafsserEntity {
  final int number;
  final String text;
  final int numberInSurah;
  final String surahName;
  final int surahNumber;

  AyahTafsserEntity({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.surahName,
    required this.surahNumber,
  });
}

class TafsserBookEntity {
  final String id;
  final String name;
  final String description;
  final bool isDownloaded;

  TafsserBookEntity({
    required this.id,
    required this.name,
    required this.description,
    this.isDownloaded = false,
  });
}
