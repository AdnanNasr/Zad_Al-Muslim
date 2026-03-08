import 'package:flutter/material.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';

class QeblaPage extends StatefulWidget {
  const QeblaPage({super.key});

  @override
  State<QeblaPage> createState() => _QeblaPageState();
}

class _QeblaPageState extends State<QeblaPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "إتجاه القبلة", center: false, profile: false),
      body: Column(),
    );
  }
}