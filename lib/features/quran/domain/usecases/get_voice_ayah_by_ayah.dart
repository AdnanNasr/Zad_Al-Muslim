import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/quran/data/repositories/voice_ayah_by_ayah_impl.dart';
import 'package:noor_quran/features/quran/domain/repositories/voice_ayah_by_ayah_repo.dart';

class GetVoiceAyahByAyah {
  final VoiceAyahByAyahImpl voiceAyahByAyahImpl;
  GetVoiceAyahByAyah(this.voiceAyahByAyahImpl);
  Either<Failure, String> call({
    required AyahVoiceParameter ayahVoiceParameter,
  }) {
    return voiceAyahByAyahImpl.getAyahVoice(ayahVoiceParameter);
  }
}
