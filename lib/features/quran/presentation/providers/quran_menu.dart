import 'package:flutter_riverpod/legacy.dart';

class QuranMenu extends StateNotifier<List<String>> {
  QuranMenu() : super([]);
}

final quranSelectProvider = StateNotifierProvider<QuranMenu, List<String>>((
  ref,
) {
  return QuranMenu();
});
