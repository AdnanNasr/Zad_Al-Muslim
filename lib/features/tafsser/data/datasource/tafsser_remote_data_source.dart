import 'package:dio/dio.dart';
import '../../../../core/utils/log/app_logger.dart';

abstract class TafsserRemoteDataSource {
  Future<dynamic> downloadTafsserJson(
    String url, {
    required void Function(double) onProgress,
  });
}

class TafsserRemoteDataSourceImpl implements TafsserRemoteDataSource {
  final Dio dio;

  TafsserRemoteDataSourceImpl(this.dio);

  @override
  Future<dynamic> downloadTafsserJson(
    String url, {
    required void Function(double) onProgress,
  }) async {
    try {
      final response = await dio.get(
        url,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received / total);
          }
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.logger.e("Download error: $e");
      rethrow;
    }
  }
}
