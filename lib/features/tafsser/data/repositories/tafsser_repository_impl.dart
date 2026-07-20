import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/tafsser_entities.dart';
import '../../domain/repositories/tafsser_repository.dart';
import '../datasource/tafsser_local_data_source.dart';
import '../datasource/tafsser_remote_data_source.dart';

class TafsserRepositoryImpl implements TafsserRepository {
  final TafsserLocalDataSource localDataSource;
  final TafsserRemoteDataSource remoteDataSource;

  TafsserRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  // قائمة الثوابت للتفاسير المتاحة (يمكن نقلها لملف مستقل لاحقاً)
  final List<TafsserBookEntity> _predefinedTafseerList = [
    TafsserBookEntity(
      name: "تفسير الجلالين",
      id: "ar.jalalayn",
      description:
          "أشهر التفاسير المختصرة؛ يقدم شرحاً وجيزاً للآيات بأسلوب يسهل فهمه للمبتدئين.",
    ),
    TafsserBookEntity(
      name: "تفسير القرطبي",
      id: "ar.qurtubi",
      description:
          "مرجع جامع لأحكام القرآن؛ يركز على استنباط الأحكام الفقهية والمسائل الشرعية.",
    ),
    TafsserBookEntity(
      name: "تفسير البغوي",
      id: "ar.baghawi",
      description:
          "يُعرف بـ 'تفسير أهل السنة'؛ يعتمد على النقل الصحيح عن السلف والصحابة.",
    ),
    TafsserBookEntity(
      name: "التفسير الميسر",
      id: "ar.muyassar",
      description:
          "تفسير معاصر أعدته نخبة من العلماء؛ يتميز بعبارات سهلة ومنقحة ومناسبة جداً.",
    ),
    TafsserBookEntity(
      name: "التفسير الوسيط",
      id: "ar.waseet",
      description:
          "تفسير يجمع بين التحليل اللفظي والبيان البلاغي؛ يتميز بأسلوبه الأدبي الرصين.",
    ),
  ];

  @override
  Future<Either<Failure, AyahTafsserEntity>> getAyahTafsser({
    required String tafsserId,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    try {
      final model = await localDataSource.getAyahTafsser(
        tafsserId: tafsserId,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
      );
      if (model != null) {
        return Right(model.toEntity());
      } else {
        return Left(CacheFailure("Tafsir not found locally."));
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TafsserBookEntity>>> getTafsserBooks() async {
    try {
      List<TafsserBookEntity> books = [];
      for (var book in _predefinedTafseerList) {
        final isDownloaded = await localDataSource.isTafsserDownloaded(book.id);
        books.add(
          TafsserBookEntity(
            id: book.id,
            name: book.name,
            description: book.description,
            isDownloaded: isDownloaded,
          ),
        );
      }
      return Right(books);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> downloadTafsser(
    String tafsserId,
    String url,
  ) async {
    try {
      final jsonMap = await remoteDataSource.downloadTafsserJson(
        url,
        onProgress: (progress) {
          // يمكن إضافة منطق لمعالجة التقدم عبر streams إذا لزم الأمر
        },
      );
      await localDataSource.saveTafsserJson(jsonMap);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> isTafsserDownloaded(String tafsserId) async {
    return await localDataSource.isTafsserDownloaded(tafsserId);
  }
}
