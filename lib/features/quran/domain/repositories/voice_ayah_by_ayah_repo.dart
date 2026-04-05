import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/constants/enums/qari_names_moratal.dart';
import 'package:noor_quran/core/constants/enums/qrai_names_ayah_by_ayah.dart';
import 'package:noor_quran/core/errors/failures.dart';

abstract class VoiceAyahByAyahRepo {
  Either<Failure, String> getAyahVoice(AyahVoiceParameter ayahVoiceParameter);
}

class AyahVoiceParameter {
  final int surahNumber;
  final int verseNumber;
  final QariModel qariModel;
  AyahVoiceParameter(this.surahNumber, this.verseNumber, this.qariModel);
}
