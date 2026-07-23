import 'package:flutter/material.dart';
import 'package:zad_al_muslim/core/common/widgets/page_header.dart';
import 'package:zad_al_muslim/core/constants/env.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';
import 'package:zad_al_muslim/core/utils/url_launcher_handler.dart';

class PrivcyPolicyPage extends StatefulWidget {
  const PrivcyPolicyPage({super.key});

  @override
  State<PrivcyPolicyPage> createState() => _PrivcyPolicyPageState();
}

class _PrivcyPolicyPageState extends State<PrivcyPolicyPage> {
  late final WebViewController webViewController;
  final String currentUrl = Env.privcyPolicyUrl;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            final url = request.url;

            if (url.startsWith("mailto:")) {
              await UrlLauncherHandler.openEmail(url);
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
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(
              tooltip: 'العودة',
              icon: Icons.lock_outline,
              title: 'سياسة الخصوصية',
              subTitle: 'تعرف على كيفية جمع معلوماتك واستخدامها وحمايتها',
            ),
            Expanded(child: WebViewWidget(controller: webViewController)),
          ],
        ),
      ),
    );
  }
}
