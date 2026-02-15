import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/view_models/models/db/islamic/tafsser/tafsser_surah.dart';
import 'package:noor_quran/view_models/providers/tafsser_book_provider.dart';

final availableTafsserBooksProvider = FutureProvider<Set<EditionModel?>>((
  ref,
) async {
  final notifier = ref.watch(tafsserBookProvider.notifier);
  return await notifier.getAllAvailableTafsserBooks();
});
