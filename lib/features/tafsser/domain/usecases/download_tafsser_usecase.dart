import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/tafsser_repository.dart';

class DownloadTafsserUseCase {
  final TafsserRepository repository;

  DownloadTafsserUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String tafsserId, String url) async {
    return await repository.downloadTafsser(tafsserId, url);
  }
}
