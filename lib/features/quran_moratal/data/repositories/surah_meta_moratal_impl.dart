import 'package:dartz/dartz.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/quran_moratal/data/datasources/surahs_moratal_meta_data.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/entities/surah_meta_moratal_entity.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/repositories/surah_meta_moratal_repo.dart';

class SurahMetaMoratalImpl implements SurahMetaMoratalRepo {
  SurahsMoratalMetaData surahsMoratalImpl;
  SurahMetaMoratalImpl(this.surahsMoratalImpl);
  @override
  Future<Either<Failure, List<SurahMetaMoratalEntity>>> getSurahsName({
    required qariUri,
  }) async {
    final Either<Failure, List<SurahMetaMoratalEntity>> surahsName =
        await surahsMoratalImpl.surahsNames(qariUri: qariUri);

    return surahsName.fold(
      (failure) {
        return Left(failure);
      },
      (surahs) {
        if (surahs.isNotEmpty) {
          return Right(surahs);
        }
        return Left(DataFailure("لم يتم العثور على أي سور لهذا القارئ."));
      },
    );
  }
}
