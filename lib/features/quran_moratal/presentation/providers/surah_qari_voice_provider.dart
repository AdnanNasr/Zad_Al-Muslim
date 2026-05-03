import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/repositories/surah_qari_voice_repo.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/usecases/get_surah_qari_voice.dart';

final surahQariVoiceProvider =
    Provider.family<Either<Failure, String>, QariParameters>((
      ref,
      qariParameters,
    ) {
      final getSurahVoice = sl<GetSurahQariVoice>();
      final url = getSurahVoice.call(qariParameters);

      return url;
    });
