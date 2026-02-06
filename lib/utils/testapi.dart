import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

double progress = 0; // متغير لتخزين النسبة

Future<void> downloadTafseer(String url, String fileName) async {
  Dio dio = Dio();
  
  // الحصول على مسار الحفظ في الهاتف
  var dir = await getApplicationDocumentsDirectory();
  String savePath = "${dir.path}/$fileName";

  try {
    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          // حساب النسبة المئوية
          progress = received / total;
          print("التحميل: ${(progress * 100).toStringAsFixed(0)}%");
          
          // هنا يجب عليك تحديث الواجهة (State Management)
        }
      },
    );
    print("تم التحميل بنجاح في: $savePath");
  } catch (e) {
    print("خطأ في التحميل: $e");
  }
}

