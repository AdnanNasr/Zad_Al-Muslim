import 'package:flutter/material.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';

class AdkarPage extends StatefulWidget {
  const AdkarPage({super.key});

  @override
  State<AdkarPage> createState() => _AdkarPageState();
}

class _AdkarPageState extends State<AdkarPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: "أذكار وأدعية",
        center: false,
        profile: false,
      ),
      body: Column(children: []),
    );
  }
}
