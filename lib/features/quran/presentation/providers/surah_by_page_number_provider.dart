import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/features/quran/domain/usecases/get_surah_number_by_page_number.dart';

final surahByPageNumberProvider = Provider.family<Map<String, int>, int>((
  ref,
  pageNumber,
) {
  final getSurahNumber = sl<GetSurahNumberByPageNumber>();
  final surahNumber = getSurahNumber.call(pageNumber);
  return surahNumber;
});
