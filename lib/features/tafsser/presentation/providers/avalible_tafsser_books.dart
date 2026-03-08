import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/features/tafsser/data/models/tafsser_surah.dart';
import 'package:noor_quran/features/tafsser/presentation/providers/tafsser_book_provider.dart';

final availableTafsserBooksProvider = FutureProvider<Set<EditionModel?>>((
  ref,
) async {
  final notifier = ref.watch(tafsserBookProvider.notifier);
  return await notifier.getAllAvailableTafsserBooks();
});
