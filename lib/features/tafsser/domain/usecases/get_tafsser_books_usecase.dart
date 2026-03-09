import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/tafsser_entities.dart';
import '../repositories/tafsser_repository.dart';

class GetTafsserBooksUseCase {
  final TafsserRepository repository;

  GetTafsserBooksUseCase(this.repository);

  Future<Either<Failure, List<TafsserBookEntity>>> call() async {
    return await repository.getTafsserBooks();
  }
}
