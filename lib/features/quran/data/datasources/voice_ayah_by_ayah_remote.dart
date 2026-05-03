import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';
import 'package:zad_al_muslim/features/quran/domain/repositories/voice_ayah_by_ayah_repo.dart';

abstract class VoiceAyahByAyahRemoteRepo {
  Either<Failure, String> getAyahVoice(AyahVoiceParameter ayahVoiceParameter);
}

class VoiceAyahByAyahRemoteImpl extends VoiceAyahByAyahRemoteRepo {
  @override
  Either<Failure, String> getAyahVoice(AyahVoiceParameter ayahVoiceParameter) {
    try {
      final String finalUrl =
          "${ayahVoiceParameter.qariModel.server}${ayahVoiceParameter.surahNumber.toString().padLeft(3, "0")}${ayahVoiceParameter.verseNumber.toString().padLeft(3, "0")}.mp3";

      AppLogger.logger.e("رابط الآية: $finalUrl");

      return Right(finalUrl);
    } catch (e) {
      return Left(UrlFailure(e.toString()));
    }
  }
}
