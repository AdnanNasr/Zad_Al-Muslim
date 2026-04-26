import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';

class HomeButton extends ConsumerStatefulWidget {
  final String text;
  final String description;
  final String? iconImage;
  final IconData? iconData;
  final Color color;
  final VoidCallback? onTap;

  const HomeButton({
    super.key,
    required this.text,
    required this.description,
    required this.color,
    this.iconImage,
    this.iconData,
    this.onTap,
  });

  @override
  ConsumerState<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends ConsumerState<HomeButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeProvider);

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(16.r),
      splashColor: Colors.white.withValues(alpha: 0.2),
      highlightColor: Colors.white.withValues(alpha: 0.1),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.color.primary,
              context.color.primary.withValues(alpha: 0.85),
              HSLColor.fromColor(context.color.primary)
                  .withLightness(
                    (HSLColor.fromColor(context.color.primary).saturation - 0.2)
                        .clamp(0.0, 1.0),
                  )
                  .toColor(),
            ],
            stops: [themeMode == ThemeMode.light ? 1.0 : 0.0, 0.0, 0.0],
          ),
          border: Border.all(
            color: context.color.onSurface.withValues(alpha: 0.15),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            children: [
              // --- زخارف عشوائية في الخلفية ---
              Positioned(
                right: -15.r,
                top: -10.r,
                child: Container(
                  width: 50.r,
                  height: 50.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                left: -25.r,
                bottom: -25.r,
                child: Container(
                  width: 90.r,
                  height: 90.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),

              // --- المحتوى الرئيسي للزر ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.iconImage != null || widget.iconData != null)
                      Container(
                        padding: EdgeInsets.all(context.witdthScreen * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: widget.iconImage != null
                            ? Image.asset(
                                widget.iconImage!,
                                height: context.witdthScreen <= 360
                                    ? 24.h
                                    : 28.h,
                              )
                            : Icon(
                                widget.iconData,
                                color: context.color.primary,
                                size: context.witdthScreen * 0.06,
                              ),
                      ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.text,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Cairo",
                              fontSize: 14.sp,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            widget.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontFamily: "Cairo",
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
