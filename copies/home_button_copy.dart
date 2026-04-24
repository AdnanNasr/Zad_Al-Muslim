import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';

class HomeButton extends ConsumerStatefulWidget {
  final String text;
  final String? iconImage;
  final IconData? iconData;
  final Color color;
  final VoidCallback? onTap;

  const HomeButton({
    super.key,
    required this.text,
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
    // we don't strictly need theme since we are customizing entirely, but we keep it
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeProvider);

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(24.r),
      splashColor: Colors.white.withValues(alpha: 0.2),
      highlightColor: Colors.white.withValues(alpha: 0.1),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          // color: context.color.primary.withValues(alpha: .85),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.iconImage != null || widget.iconData != null)
              Container(
                padding: EdgeInsets.all(context.witdthScreen * 0.025),
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
                        height: context.witdthScreen <= 360 ? 30.h : 35.h,
                      )
                    : Icon(
                        widget.iconData,
                        color: Colors.white,
                        size: context.witdthScreen * 0.07,
                      ),
              ),
            SizedBox(height: context.heightScreen * 0.012),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                widget.text,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Cairo",
                  fontSize: context.witdthScreen * 0.035,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
