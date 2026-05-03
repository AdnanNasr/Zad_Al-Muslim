import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/quran/data/datasources/voice_ayah_by_ayah_remote.dart';
import 'package:zad_al_muslim/features/quran/domain/repositories/voice_ayah_by_ayah_repo.dart';

class VoiceAyahByAyahImpl extends VoiceAyahByAyahRepo {
  final VoiceAyahByAyahRemoteImpl voiceAyahByAyahRemoteImpl;
  VoiceAyahByAyahImpl(this.voiceAyahByAyahRemoteImpl);
  @override
  Either<Failure, String> getAyahVoice(AyahVoiceParameter ayahVoiceParameter) {
    return voiceAyahByAyahRemoteImpl.getAyahVoice(ayahVoiceParameter);
  }
}
