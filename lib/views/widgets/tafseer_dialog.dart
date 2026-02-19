import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/extensions/sizes_ext.dart';
import 'package:noor_quran/views/widgets/tafsser_buttons.dart';

class TafseerDialog extends StatelessWidget {
  final TafsserInfo tafsserInfo;
  const TafseerDialog({super.key, required this.tafsserInfo});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      // backgroundColor: Colors.black,
      title: Center(
        child: Text(
          tafsserInfo.name,
          style: const TextStyle(
            fontFamily: "Cairo",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      contentPadding: EdgeInsetsGeometry.all(16.r),
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
