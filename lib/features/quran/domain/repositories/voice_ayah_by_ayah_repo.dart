import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';

abstract class VoiceAyahByAyahRepo {
  Either<Failure, String> getAyahVoice(AyahVoiceParameter ayahVoiceParameter);
}

class AyahVoiceParameter {
  final int surahNumber;
  final int verseNumber;
  AyahVoiceParameter(this.surahNumber, this.verseNumber);
}
