import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/tafsser_entities.dart';
import '../repositories/tafsser_repository.dart';

class GetAyahTafsserUseCase {
  final TafsserRepository repository;

  GetAyahTafsserUseCase(this.repository);

  Future<Either<Failure, AyahTafsserEntity>> call({
    required String tafsserId,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    return await repository.getAyahTafsser(
      tafsserId: tafsserId,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
  }
}
