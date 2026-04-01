import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/quran_moratal/domain/repositories/surah_qari_voice_repo.dart';

abstract class SurahQariRemoteSourcesRepo {
  Either<Failure, String> surahQariRemoteSources(QariParameters qariParameters);
}

class SurahQariRemoteSourcesImpl extends SurahQariRemoteSourcesRepo {
  @override
  Either<Failure, String> surahQariRemoteSources(
    QariParameters qariParameters,
  ) {
    try {
      final serverUrl = qariParameters.serverUrl;
      final surahNumber = qariParameters.surahNumber.toString().padLeft(3, "0");

      final url = "$serverUrl$surahNumber.mp3";

      return Right(url);
    } catch (e) {
      return Left(UrlFailure(e.toString()));
    }
  }
}
