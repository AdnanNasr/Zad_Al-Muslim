import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/extensions/sizes_ext.dart';

class SettingsContainer extends ConsumerWidget {
  final String? title;
  final List<Widget> settingsCards;
  const SettingsContainer({super.key, this.title, required this.settingsCards});

  // checkTheme -> return Color
  Color checkTheme({
    required themeMode,
    required lightColor,
    required darkColor,
  }) {
    return themeMode == ThemeMode.light ? lightColor : darkColor;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = context.color.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: TextStyle(
              fontSize: context.witdthScreen * 0.05.sp,
              color: primary,
              fontWeight: FontWeight.bold,
              fontFamily: "Cairo",
            ),
          ),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...settingsCards.asMap().entries.map((entries) {
                final index = entries.key;
                final card = entries.value;
                return Column(
                  children: [
                    card,
                    if (index != settingsCards.length - 1) ...[
                      Divider(
                        color: primary.withValues(alpha: 0.18),
                        thickness: 1.2,
                        height: 0,
                      ),
                    ],
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
