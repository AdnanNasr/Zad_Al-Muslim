import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/features/settings/presentation/providers/app_settings_provider.dart';

class FontSizeDialog extends ConsumerWidget {
  const FontSizeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize = ref.watch(appSettingsProvider).adkarFontSize;

    return SimpleDialog(
      title: const Text(
        "حجم خط الأذكار",
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: "Cairo", fontWeight: FontWeight.bold),
      ),
      contentPadding: EdgeInsets.all(20.r),
      children: [
        Text(
          "تعديل حجم الخط المعروض في صفحة الأذكار",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.sp, fontFamily: "Cairo"),
        ),
        SizedBox(height: 20.h),
        Slider(
          value: fontSize,
          min: 18.0,
          max: 40.0,
          divisions: 22,
          label: fontSize.round().toString(),
          onChanged: (value) {
            ref.read(appSettingsProvider.notifier).setAdkarFontSize(value);
          },
        ),
        SizedBox(height: 10.h),
        Text(
          "بِسمِ اللَّهِ الرَّحمٰنِ الرَّحيمِ",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize.sp, fontFamily: "Naskh"),
        ),
        SizedBox(height: 20.h),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("تم", style: TextStyle(fontFamily: "Cairo")),
        ),
      ],
    );
  }
}
