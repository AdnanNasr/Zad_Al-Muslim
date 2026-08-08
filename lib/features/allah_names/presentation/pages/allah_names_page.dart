import 'package:flutter/material.dart';
import 'package:zad_al_muslim/core/common/widgets/page_header.dart';

class AllahNamesPage extends StatelessWidget {
  const AllahNamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              tooltip: "العودة",
              title: "أسماء الله الحسنى",
              icon: Icons.auto_awesome_sharp,
            ),
            Expanded(child: Placeholder()),
          ],
        ),
      ),
    );
  }
}
