import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/features/tafsser/domain/entities/tafsser_entities.dart';
import 'package:noor_quran/features/tafsser/domain/usecases/get_ayah_tafsser_usecase.dart';

final ayahTafsserProvider =
    FutureProvider.family<
      AyahTafsserEntity?,
      ({String tafsserId, int surahNumber, int ayahNumber})
    >((ref, arg) async {
      final getAyahTafsser = sl<GetAyahTafsserUseCase>();
      final result = await getAyahTafsser(
        tafsserId: arg.tafsserId,
        surahNumber: arg.surahNumber,
        ayahNumber: arg.ayahNumber,
      );
      return result.fold((failure) => null, (entity) => entity);
    });
