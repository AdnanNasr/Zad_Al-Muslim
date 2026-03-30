import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/quran/data/datasources/voice_ayah_by_ayah_remote.dart';
import 'package:noor_quran/features/quran/domain/repositories/voice_ayah_by_ayah_repo.dart';

class VoiceAyahByAyahImpl extends VoiceAyahByAyahRepo {
  final VoiceAyahByAyahRemoteImpl voiceAyahByAyahRemoteImpl;
  VoiceAyahByAyahImpl(this.voiceAyahByAyahRemoteImpl);
  @override
  Either<Failure, String> getAyahVoice(AyahVoiceParameter ayahVoiceParameter) {
    return voiceAyahByAyahRemoteImpl.getAyahVoice(ayahVoiceParameter);
  }
}
