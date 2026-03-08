import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeProvider);

    return InkWell(
      onTap: widget.onTap,
      splashColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(40),
      child: Ink(
        decoration: BoxDecoration(
          gradient: themeMode == ThemeMode.light
              ? LinearGradient(
                  colors: [
                    widget.color.withValues(alpha: 0.8),
                    widget.color.withValues(alpha: 0.9),
                  ],
                )
              : LinearGradient(
                  colors: [
                    widget.color.withValues(alpha: 0.8),
                    widget.color.withValues(alpha: 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(39.r),
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.iconImage != null)
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  shape: BoxShape.circle,
                  boxShadow: themeMode == ThemeMode.light
                      ? [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).shadowColor.withValues(alpha: 0.6),
                            offset: const Offset(0, 2),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
                padding: EdgeInsets.all(context.witdthScreen * 0.02),
                child: Image.asset(
                  widget.iconImage!,
                  height: context.witdthScreen <= 360 ? 45.h : 40.h,
                ),
              )
            else if (widget.iconData != null)
              Icon(
                widget.iconData,
                color: Theme.of(context).colorScheme.onPrimary,
                size: context.witdthScreen * 0.08,
              ),
            SizedBox(height: context.heightScreen * 0.009),
            Text(
              widget.text,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontFamily: "Cairo",
                fontSize: context.witdthScreen * 0.035,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
