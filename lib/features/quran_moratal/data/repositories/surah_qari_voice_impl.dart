import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/quran_moratal/data/datasources/surah_qari_remote_sources.dart';
import 'package:noor_quran/features/quran_moratal/domain/repositories/surah_qari_voice_repo.dart';

class SurahQariVoiceImpl extends SurahQariVoiceRepo {
  final SurahQariRemoteSourcesImpl surahQariRemoteSourcesImpl;
  SurahQariVoiceImpl(this.surahQariRemoteSourcesImpl);
  @override
  Either<Failure, String> getSurahQariVoice(QariParameters qariParameters) {
    return surahQariRemoteSourcesImpl.surahQariRemoteSources(qariParameters);
  }
}
