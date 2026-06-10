import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:qcf_quran/qcf_quran.dart';
import 'package:zad_al_muslim/core/constants/enums/surahs_name.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';
import 'package:zad_al_muslim/features/quran_moratal/data/models/surah_meta_moratal_model.dart';

abstract class SurahsMoratalMetaData {
  Future<Either<Failure, List<SurahMetaMoratalModel>>> surahsNames({
    required String qariUri,
  });
}

class SurahsMoratalMetaDataImpl implements SurahsMoratalMetaData {
  @override
  Future<Either<Failure, List<SurahMetaMoratalModel>>> surahsNames({
    required String qariUri,
  }) async {
    final Dio dio = Dio();
    List<SurahMetaMoratalModel> surahsMeta = [];

    try {
      final response = await dio.get(qariUri);

      if (response.statusCode == 200) {
        final dom.Document document = parser.parse(response.data);
        final List<dom.Element> elements = document.querySelectorAll('a');

        // تعبير نمطي للبحث عن 3 أرقام متتالية تنتهي بـ .mp3
        final RegExp regex = RegExp(r'(\d{3})\.mp3');

        for (var element in elements) {
          // جلب قيمة الـ href (مثال: "064.mp3")
          final String? href = element.attributes['href'];
          if (href == null) continue;

          // التحقق مما إذا كان الرابط يحتوي على صيغة اسم السورة (3 أرقام)
          final match = regex.firstMatch(href);

          if (match != null) {
            // استخراج النص (مثلاً "064") وتحويله إلى رقم صحيح (64)
            final String surahNumberStr = match.group(1)!;
            final int surahIndex = int.parse(surahNumberStr);

            // الحماية: التأكد من أن الرقم يقع في نطاق سور القرآن (1 إلى 114)
            if (surahIndex >= 1 && surahIndex <= 114) {
              final pageNumber = getPageNumber(surahIndex, 1);
              final String arabicName = SurahNames.getFormattedName(surahIndex);
              final String englishName = getSurahName(surahIndex);
              final int juzzNumber = getJuzNumber(surahIndex, 1);
              final int verseCount = getVerseCount(surahIndex);

              if (arabicName.isNotEmpty) {
                surahsMeta.add(
                  SurahMetaMoratalModel.fromString(
                    surahIndex,
                    pageNumber,
                    arabicName,
                    englishName,
                    juzzNumber,
                    verseCount,
                  ),
                );
              }
            }
          }
        }

        AppLogger.logger.i("تم جلب عدد سور متوفرة: ${surahsMeta.length}");
        return Right(surahsMeta);
      } else {
        return Left(DataFailure("حصل خطأ اثناء معالجة سور القرآن الكريم."));
      }
    } catch (e) {
      AppLogger.logger.e("خطأ في جلب بيانات السور: $e");
      return Left(DataFailure("فشل الاتصال بالخادم، يرجى المحاولة لاحقاً."));
    }
  }
}
