import 'package:noor_quran/core/constants/enums/my_enums.dart';

class HadithEntity {
  final int id;
  final String hadith;
  final String hadithNarrator;
  final bool isFeatured;
  final String topic;
  final HadithGrade grade;
  final String book;

  HadithEntity({
    required this.id,
    required this.hadith,
    required this.hadithNarrator,
    required this.isFeatured,
    required this.topic,
    required this.grade,
    required this.book,
  });
}

class HadithFiltersEntity {
  final String? book;
  final String? narrator;
  final String? topic;
  final HadithGrade? grade;
  final bool featuredOnly;

  HadithFiltersEntity({
    this.book,
    this.narrator,
    this.topic,
    this.grade,
    this.featuredOnly = false,
  });

  HadithFiltersEntity copyWith({
    String? book,
    bool clearBook = false,
    String? narrator,
    bool clearNarrator = false,
    String? topic,
    bool clearTopic = false,
    HadithGrade? grade,
    bool clearGrade = false,
    bool? featuredOnly,
  }) {
    return HadithFiltersEntity(
      book: clearBook ? null : (book ?? this.book),
      narrator: clearNarrator ? null : (narrator ?? this.narrator),
      topic: clearTopic ? null : (topic ?? this.topic),
      grade: clearGrade ? null : (grade ?? this.grade),
      featuredOnly: featuredOnly ?? this.featuredOnly,
    );
  }
}
