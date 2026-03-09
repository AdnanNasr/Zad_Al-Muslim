import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/constants/enums/my_enums.dart';
import 'package:noor_quran/features/hadith/domain/entities/hadith_entity.dart';
import 'package:noor_quran/features/hadith/domain/usecases/get_hadiths_usecase.dart';
import 'package:noor_quran/features/hadith/domain/usecases/update_hadith_usecase.dart';
import 'package:noor_quran/core/di/injection_container.dart';

class HadithNotifier extends AsyncNotifier<List<HadithEntity>> {
  HadithFiltersEntity _filters = HadithFiltersEntity();
  
  GetHadithsUseCase get _getHadithsUseCase => sl<GetHadithsUseCase>();
  UpdateHadithUseCase get _updateHadithUseCase => sl<UpdateHadithUseCase>();

  @override
  FutureOr<List<HadithEntity>> build() async {
    return _fetchHadiths();
  }

  Future<List<HadithEntity>> _fetchHadiths() async {
    final result = await _getHadithsUseCase(_filters);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (hadiths) => hadiths,
    );
  }

  // ---------------- CRUD (العمليات على البيانات) ----------------

  Future<void> updateHadithGrade(HadithEntity entity, HadithGrade grade) async {
    final updatedEntity = HadithEntity(
      id: entity.id,
      hadith: entity.hadith,
      hadithNarrator: entity.hadithNarrator,
      isFeatured: entity.isFeatured,
      topic: entity.topic,
      grade: grade,
      book: entity.book,
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await _updateHadithUseCase(updatedEntity);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) => _fetchHadiths(),
      );
    });
  }

  Future<void> toggleIsFeatured(HadithEntity entity) async {
    final updatedEntity = HadithEntity(
      id: entity.id,
      hadith: entity.hadith,
      hadithNarrator: entity.hadithNarrator,
      isFeatured: !entity.isFeatured,
      topic: entity.topic,
      grade: entity.grade,
      book: entity.book,
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await _updateHadithUseCase(updatedEntity);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) => _fetchHadiths(),
      );
    });
  }

  // ---------------- GETTERS (الحصول على القيم الحالية) ----------------

  bool get isFilterEmpty => 
    _filters.book == null && 
    _filters.topic == null && 
    _filters.narrator == null && 
    _filters.grade == null && 
    !_filters.featuredOnly;

  String? get currentBook => _filters.book;
  String? get currentNarrator => _filters.narrator;
  String? get currentTopic => _filters.topic;
  
  String? get currentGradeText {
    if (_filters.grade == null) return null;
    switch (_filters.grade!) {
      case HadithGrade.sahih: return "صحيح";
      case HadithGrade.hasan: return "حسن";
      case HadithGrade.daif: return "ضعيف";
    }
  }

  // ---------------- SETTERS (تعديل قيم الفلاتر) ----------------

  void setBook(String? value) { 
    _filters = _filters.copyWith(book: value, clearBook: value == null); 
    ref.invalidateSelf();
  }

  void setNarrator(String? value) { 
    _filters = _filters.copyWith(narrator: value, clearNarrator: value == null); 
    ref.invalidateSelf();
  }

  void setTopic(String? value) { 
    _filters = _filters.copyWith(topic: value, clearTopic: value == null); 
    ref.invalidateSelf();
  }
  
  void setGradeFromText(String? value) {
    HadithGrade? grade;
    switch (value) {
      case "صحيح": grade = HadithGrade.sahih; break;
      case "حسن": grade = HadithGrade.hasan; break;
      case "ضعيف": grade = HadithGrade.daif; break;
    }
    _filters = _filters.copyWith(grade: grade, clearGrade: value == null);
    ref.invalidateSelf();
  }

  void setFeatured(bool value) {
    _filters = _filters.copyWith(featuredOnly: value);
    ref.invalidateSelf();
  }

  void clearFilters() {
    _filters = HadithFiltersEntity();
    ref.invalidateSelf();
  }
}

// ---------------- PROVIDER DEFINITION ----------------

final hadithProvider = AsyncNotifierProvider<HadithNotifier, List<HadithEntity>>(() {
  return HadithNotifier();
});