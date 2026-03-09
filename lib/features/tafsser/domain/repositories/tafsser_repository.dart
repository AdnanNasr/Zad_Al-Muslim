import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/tafsser_entities.dart';

abstract class TafsserRepository {
  Future<Either<Failure, AyahTafsserEntity>> getAyahTafsser({
    required String tafsserId,
    required int surahNumber,
    required int ayahNumber,
  });

  Future<Either<Failure, List<TafsserBookEntity>>> getTafsserBooks();

  Future<Either<Failure, Unit>> downloadTafsser(String tafsserId, String url);

  Future<bool> isTafsserDownloaded(String tafsserId);
}
