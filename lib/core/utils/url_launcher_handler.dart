import 'package:url_launcher/url_launcher.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';

class UrlLauncherHandler {
  static Future<void> openEmail(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppLogger.logger.e("حصل خطأ اثناء التعامل مع الإيميل");
    }
  }
}
