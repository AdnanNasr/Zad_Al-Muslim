import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/quran_moratal/domain/repositories/surah_qari_voice_repo.dart';
import 'package:noor_quran/features/quran_moratal/domain/usecases/get_surah_qari_voice.dart';

final surahQariVoiceProvider =
    Provider.family<Either<Failure, String>, QariParameters>((
      ref,
      qariParameters,
    ) {
      final getSurahVoice = sl<GetSurahQariVoice>();
      final url = getSurahVoice.call(qariParameters);

      return url;
    });
