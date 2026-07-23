import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.accentColor,
    required this.settingsCards,
  });

  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Color? accentColor;
  final List<Widget> settingsCards;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = accentColor ?? scheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                if (icon != null) ...[
                  Container(
                    width: 34.r,
                    height: 34.r,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(11.r),
                    ),
                    child: Icon(icon, size: 18.sp, color: accent),
                  ),
                  SizedBox(width: 10.w),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title!,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 1.h),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w500,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (title != null) SizedBox(height: 11.h),
        Material(
          color: scheme.surface,
          surfaceTintColor: Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          clipBehavior: Clip.antiAlias,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              children: [
                for (var index = 0; index < settingsCards.length; index++) ...[
                  settingsCards[index],
                  if (index != settingsCards.length - 1)
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 66.w),
                      child: Divider(
                        color: scheme.outlineVariant.withValues(alpha: 0.65),
                        height: 1,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
