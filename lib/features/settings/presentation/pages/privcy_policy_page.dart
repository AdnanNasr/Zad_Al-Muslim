import 'package:flutter/material.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/core/constants/env.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:noor_quran/core/utils/log/app_logger.dart';

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
    webViewController =
        WebViewController() // TODO: handle errors when click on email links
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
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
        title: "سياسة الخصوصية",
        center: false,
        profile: false,
      ),
      body: WebViewWidget(controller: webViewController),
    );
  }
}
