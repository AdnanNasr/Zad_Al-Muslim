import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/quran_moratal/data/repositories/surah_qari_voice_impl.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/repositories/surah_qari_voice_repo.dart';

class GetSurahQariVoice {
  SurahQariVoiceImpl surahQariVoiceImpl;
  GetSurahQariVoice(this.surahQariVoiceImpl);
  Either<Failure, String> call(QariParameters qariParameters) {
    return surahQariVoiceImpl.getSurahQariVoice(qariParameters);
  }
}
