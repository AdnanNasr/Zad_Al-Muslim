import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/entities/surah_meta_moratal_entity.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/usecases/get_surahs_moratal_names.dart';

final surahsNamesMoratalProvider =
    FutureProvider.family<
      Either<Failure, List<SurahMetaMoratalEntity>>,
      String
    >((ref, String qariUri) async {
      return await sl<GetSurahsMoratalNames>().call(qariUri: qariUri);
    });
