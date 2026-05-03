import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/features/hadith/domain/entities/hadith_entity.dart';
import 'package:zad_al_muslim/features/hadith/domain/usecases/get_hadiths_usecase.dart';
import 'package:zad_al_muslim/features/hadith/domain/usecases/update_hadith_usecase.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';

class HadithNotifier extends AsyncNotifier<List<HadithEntity>> {
  HadithFiltersEntity _filters = HadithFiltersEntity();
  bool _hasMore = true;

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
      (hadiths) {
        _hasMore = hadiths.length >= _filters.limit;
        return hadiths;
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading || state.hasError) return;

    final currentHadiths = state.value ?? [];
    _filters = _filters.copyWith(offset: currentHadiths.length);

    try {
      final result = await _getHadithsUseCase(_filters);
      result.fold(
        (failure) => throw Exception(failure.message),
        (newHadiths) {
          _hasMore = newHadiths.length >= _filters.limit;
          state = AsyncData([...currentHadiths, ...newHadiths]);
        },
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // ---------------- CRUD (العمليات على البيانات) ----------------

  Future<void> toggleIsFeatured(HadithEntity entity) async {
    final updatedEntity = entity.copyWith(isFavorite: !entity.isFavorite);

    // احفظ التغيير في قاعدة البيانات
    final result = await _updateHadithUseCase(updatedEntity);
    result.fold(
      (failure) {
        // يمكنك إظهار رسالة خطأ هنا إن أردت
      },
      (_) {
        // قم بتعديل الحالة المحلية (State) فقط بدون تصفير الـ offset
        // هذا يمنع عمل rebuild كامل للصفحة ويحافظ على موضع التمرير
        if (state.hasValue && state.value != null) {
          final list = List<HadithEntity>.from(state.value!);
          final index = list.indexWhere((e) => e.isarId == entity.isarId);
          if (index != -1) {
            list[index] = updatedEntity;
            state = AsyncData(list);
          }
        }
      },
    );
  }

  // ---------------- GETTERS (الحصول على القيم الحالية) ----------------

  bool get isFilterEmpty =>
      _filters.bookNumber == null &&
      (_filters.searchQuery == null || _filters.searchQuery!.isEmpty) &&
      !_filters.favoritesOnly;

  int? get currentBookNumber => _filters.bookNumber;
  String? get currentSearchQuery => _filters.searchQuery;
  bool get hasMore => _hasMore;

  // ---------------- SETTERS (تعديل قيم الفلاتر) ----------------

  void setBook(int? bookNumber) {
    _filters = _filters.copyWith(
      bookNumber: bookNumber,
      clearBook: bookNumber == null,
      offset: 0,
    );
    _hasMore = true;
    ref.invalidateSelf();
  }

  void setSearchQuery(String? query) {
    _filters = _filters.copyWith(
      searchQuery: query,
      clearSearch: query == null || query.isEmpty,
      offset: 0,
    );
    _hasMore = true;
    ref.invalidateSelf();
  }

  void setFavoritesOnly(bool value) {
    _filters = _filters.copyWith(
      favoritesOnly: value,
      offset: 0,
    );
    _hasMore = true;
    ref.invalidateSelf();
  }

  void clearFilters() {
    _filters = HadithFiltersEntity();
    _hasMore = true;
    ref.invalidateSelf();
  }
}

// ---------------- PROVIDER DEFINITION ----------------

final hadithProvider =
    AsyncNotifierProvider<HadithNotifier, List<HadithEntity>>(() {
      return HadithNotifier();
    });
