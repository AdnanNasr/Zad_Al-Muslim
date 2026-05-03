import 'package:zad_al_muslim/core/constants/enums/my_enums.dart';

class HadithEntity {
  final int isarId; // Isar autoIncrement id للتعديل المباشر
  final String hadithnumber;
  final String text;
  final String textNormalized;
  final Reference reference;
  final bool isFavorite;

  HadithEntity({
    this.isarId = 0,
    required this.hadithnumber,
    required this.reference,
    required this.text,
    required this.textNormalized,
    this.isFavorite = false,
  });

  HadithEntity copyWith({bool? isFavorite, String? textNormalized}) {
    return HadithEntity(
      isarId: isarId,
      hadithnumber: hadithnumber,
      text: text,
      textNormalized: textNormalized ?? this.textNormalized,
      reference: reference,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// اسم الكتاب بالعربية بناءً على رقمه
  String get bookName =>
      SahihBukhariBook.fromId(reference.book).arabicName;
}

class HadithFiltersEntity {
  final int? bookNumber;
  final String? searchQuery;
  final bool favoritesOnly;
  final int offset;
  final int limit;

  HadithFiltersEntity({
    this.bookNumber,
    this.searchQuery,
    this.favoritesOnly = false,
    this.offset = 0,
    this.limit = 30,
  });

  HadithFiltersEntity copyWith({
    int? bookNumber,
    bool clearBook = false,
    String? searchQuery,
    bool clearSearch = false,
    bool? favoritesOnly,
    int? offset,
    int? limit,
  }) {
    return HadithFiltersEntity(
      bookNumber: clearBook ? null : (bookNumber ?? this.bookNumber),
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
    );
  }
}

class Reference {
  final int book;
  final int hadith;
  Reference({required this.book, required this.hadith});
}
