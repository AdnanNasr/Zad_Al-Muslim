import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/constants/enums/my_enums.dart';
import 'package:noor_quran/core/constants/surahs.dart';
import 'package:noor_quran/view_models/providers/language_provider.dart';

class SurahNamesProvider extends StateNotifier<List<SurahItem>> {
  SurahNamesProvider() : super(const []);

  AppLocale? _currentLocale;

  void init(AppLocale locale) {
    if (_currentLocale == locale && state.isNotEmpty) return;

    _currentLocale = locale;
    _loadSurahs(locale);
  }

  void _loadSurahs(AppLocale locale) {
    final List<SurahItem> surahs = [];

    for (int i = 0; i < quranSurahs.length; i++) {
      final surah = quranSurahs[i];

      surahs.add(
        SurahItem(
          index: i,
          name: locale == AppLocale.ar ? surah.name : surah.englishName,
          pageIndex: surah.startOnPage - 1,
        ),
      );
    }

    state = List.unmodifiable(surahs);
  }

  int getPageIndexBySurah(int index) {
    return state.firstWhere((s) => s.index == index).pageIndex;
  }
}

class SurahItem {
  final int index;
  final String name;
  final int pageIndex;

  const SurahItem({
    required this.index,
    required this.name,
    required this.pageIndex,
  });
}

final surahsProvider =
    StateNotifierProvider<SurahNamesProvider, List<SurahItem>>((ref) {
      final language = ref.watch(languageProvider);
      final notifier = SurahNamesProvider();
      notifier.init(language);
      return notifier;
    });
