import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/quran/domain/repositories/voice_ayah_by_ayah_repo.dart';
import 'package:zad_al_muslim/features/quran/domain/usecases/get_voice_ayah_by_ayah.dart';

final voiceAyahByAyahProvider =
    Provider.family<Either<Failure, String>, AyahVoiceParameter>((
      ref,
      ayahVoiceParameter,
    ) {
      final getVoiceAyahByAyah = sl<GetVoiceAyahByAyah>();
      final response = getVoiceAyahByAyah.call(
        ayahVoiceParameter: ayahVoiceParameter,
      );

      return response.fold(
        (failure) {
          return Left(UrlFailure(failure.message));
        },
        (url) {
          return Right(url);
        },
      );
    });
