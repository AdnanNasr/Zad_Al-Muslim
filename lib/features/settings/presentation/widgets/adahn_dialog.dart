import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';

class AdahnDialog extends StatefulWidget {
  const AdahnDialog({super.key});

  @override
  State<AdahnDialog> createState() => _AdahnDialogState();
}

class _AdahnDialogState extends State<AdahnDialog> {
  List<String> options = [
    "أذان الحرم المكي (الشيخ علي ملا)",
    "أذان المسجد النبوي (الشيخ عصام بخاري)",
    "أذان المسجد الأقصى (القدس)",
    "أذان مصري (الشيخ محمد رفعت)",
    "أذان مصري (الشيخ عبد الباسط عبد الصمد)",
    "الأذان الجماعي (الجامع الأموي بدمشق)",
    "أذان على مقام الحجاز (النمط المدني)",
    "أذان على مقام الرست (النمط التركي)",
    "أذان على مقام الصبا (أذان حزين)",
    "أذان المغرب العربي (النمط القيرواني)",
  ]; // temp
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsetsGeometry.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.multitrack_audio_sharp,
                  color: context.color.primary,
                ),
                SizedBox(width: 8.w),
                const Text(
                  "صوت الأذان",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                const Text(
                  "(قيد العمل)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: context.mediaQueryHeight * 0.5,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    options.length,
                    (index) => Column(
                      children: [
                        ListTile(
                          title: Text(
                            options[index],
                            style: TextStyle(
                              fontFamily: "Cairo",
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "إلغاء",
                style: TextStyle(
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
