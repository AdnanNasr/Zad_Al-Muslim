import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/tafsser/domain/entities/tafsser_entities.dart';
import 'package:zad_al_muslim/features/tafsser/domain/usecases/get_tafsser_books_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tafsser_book.g.dart';

@riverpod
class TafsserBook extends _$TafsserBook {
  @override
  Future<Either<Failure, List<TafsserBookEntity>>> build() async {
    // نقوم بجلب البيانات مباشرة عند بناء الـ Provider
    return getTafsserBooks();
  }

  Future<Either<Failure, List<TafsserBookEntity>>> getTafsserBooks() async {
    final getTafsserBooksUseCase = sl<GetTafsserBooksUseCase>();
    final result = await getTafsserBooksUseCase();

    return result.fold(
      (failure) => Left(
        failure,
      ), // مرر الـ failure القادم من الـ UseCase مباشرة أو استخدم DataFailure() إذا كنت تفضل ذلك
      (books) => Right(books),
    );
  }

  // إذا كنت تريد عمل تحديث (Refresh) للبيانات مستقبلاً من الواجهة:
  Future<void> refreshTafsserBooks() async {
    state = const AsyncValue.loading(); // تغيير الحالة إلى التحميل
    state = await AsyncValue.guard(
      () => getTafsserBooks(),
    ); // تحديث الحالة بالبيانات الجديدة
  }
}
