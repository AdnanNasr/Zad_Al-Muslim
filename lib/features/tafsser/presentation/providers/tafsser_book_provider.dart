import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/features/tafsser/domain/entities/tafsser_entities.dart';
import 'package:noor_quran/features/tafsser/domain/usecases/get_tafsser_books_usecase.dart';

final tafsserBooksProvider = FutureProvider<List<TafsserBookEntity>>((
  ref,
) async {
  final getTafsserBooks = sl<GetTafsserBooksUseCase>();
  final result = await getTafsserBooks();
  return result.fold((failure) => [], (books) => books);
});

final selectedTafsserBookProvider = StateProvider<TafsserBookEntity?>(
  (ref) => null,
);
