import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingCards extends StatelessWidget {
  const SettingCards({
    super.key,
    required this.icon,
    required this.text,
    this.subText,
    this.valueText,
    this.onTap,
    this.trallingIcon,
    this.toggle,
    this.borderRadius,
    this.onChanged,
    this.widget,
    this.forgroundColor,
    this.hero,
    this.heroId,
    this.switchValue,
    this.destructive = false,
  });

  final Either<Widget, IconData> icon;
  final String text;
  final String? subText;
  final String? valueText;
  final VoidCallback? onTap;
  final IconData? trallingIcon;
  final bool? toggle;
  final BorderRadius? borderRadius;
  final ValueChanged<bool>? onChanged;
  final Widget? widget;
  final Color? forgroundColor;
  final bool? hero;
  final String? heroId;
  final bool? switchValue;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = destructive
        ? scheme.error
        : (forgroundColor ?? scheme.primary);
    final enabled = onTap != null || onChanged != null;

    return Semantics(
      button: onTap != null,
      enabled: enabled,
      label: [
        text,
        if (subText != null) subText,
        if (valueText != null) valueText,
      ].join('، '),
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 64.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Row(
              children: [
                Container(
                  width: 42.r,
                  height: 42.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                  child: icon.fold(
                    (child) => IconTheme(
                      data: IconThemeData(color: accent, size: 22.sp),
                      child: child,
                    ),
                    (iconData) => Icon(iconData, size: 22.sp, color: accent),
                  ),
                ),
                SizedBox(width: 11.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w700,
                          color: destructive ? scheme.error : scheme.onSurface,
                          height: 1.4,
                        ),
                      ),
                      if (subText != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          subText!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w500,
                            color: scheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                if (toggle == true)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (valueText != null) ...[
                        Container(
                          constraints: BoxConstraints(maxWidth: 78.w),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            valueText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: accent,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                      ],
                      Switch(value: switchValue ?? false, onChanged: onChanged),
                    ],
                  )
                else if (widget != null)
                  widget!
                else ...[
                  if (valueText != null)
                    Container(
                      constraints: BoxConstraints(maxWidth: 115.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        valueText!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w700,
                          color: accent,
                        ),
                      ),
                    ),
                  if (onTap != null) ...[
                    SizedBox(width: 5.w),
                    Icon(
                      trallingIcon ?? Icons.arrow_forward_ios,
                      size: 16.sp,
                      color: destructive
                          ? scheme.error
                          : scheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
