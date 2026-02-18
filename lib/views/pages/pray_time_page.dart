import 'package:flutter/material.dart';
import 'package:noor_quran/views/widgets/custom_app_bar.dart';

class PrayTimePage extends StatefulWidget {
  const PrayTimePage({super.key});

  @override
  State<PrayTimePage> createState() => _PrayTimePageState();
}

class _PrayTimePageState extends State<PrayTimePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "أوقات الصلاة", center: false, profile: false),
      body: Column(
        children: [
          Text("Data")
        ],
      ),
    );
  }
}