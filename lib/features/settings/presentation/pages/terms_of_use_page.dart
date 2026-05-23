import 'package:flutter/material.dart';
import 'package:zad_al_muslim/core/common/widgets/custom_app_bar.dart';
import 'package:zad_al_muslim/core/constants/env.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zad_al_muslim/core/utils/url_launcher_handler.dart';

class TermsOfUsePage extends StatefulWidget {
  const TermsOfUsePage({super.key});

  @override
  State<TermsOfUsePage> createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> {
  late final WebViewController webViewController;
  final String currentUrl = Env.termsOfuseUrl;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final String url = request.url;

            if (url.startsWith("mailto:")) {
              UrlLauncherHandler.openEmail(url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            AppLogger.logger.e("فشل تحميل الصفحة: ${error.description}");
            AppLogger.logger.e("نوع الخطأ: ${error.errorType}");
          },
        ),
      )
      ..loadRequest(Uri.parse(currentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "اتفاقية الاستخدام",
        center: false,
        themeMode: false,
      ),
      body: WebViewWidget(controller: webViewController),
    );
  }
}
