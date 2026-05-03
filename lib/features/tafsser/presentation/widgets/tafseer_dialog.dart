import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/sizes_ext.dart';
import '../../domain/entities/tafsser_entities.dart';

class TafseerDialog extends StatelessWidget {
  final TafsserBookEntity tafsserInfo;
  const TafseerDialog({super.key, required this.tafsserInfo});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(
        child: Text(
          tafsserInfo.name,
          style: const TextStyle(
            fontFamily: "Cairo",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      contentPadding: EdgeInsets.all(16.r),
      children: [
        Text(
          tafsserInfo.description,
          style: TextStyle(
            fontSize: context.witdthScreen * 0.042,
            fontFamily: "Tajawal",
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
