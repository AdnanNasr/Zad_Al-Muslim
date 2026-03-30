import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/quran/domain/repositories/voice_ayah_by_ayah_repo.dart';
import 'package:noor_quran/features/quran/domain/usecases/get_voice_ayah_by_ayah.dart';

final voiceAyahByAyahProvider =
    ProviderFamily<Either<Failure, String>, AyahVoiceParameter>((
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
