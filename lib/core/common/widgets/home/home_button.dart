import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeButton extends ConsumerStatefulWidget {
  const HomeButton({
    super.key,
    required this.text,
    required this.description,
    required this.color,
    this.iconImage,
    this.iconData,
    this.onTap,
  });

  final String text;
  final String description;
  final String? iconImage;
  final IconData? iconData;
  final Color color;
  final VoidCallback? onTap;

  @override
  ConsumerState<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends ConsumerState<HomeButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark
        ? colorScheme.surfaceContainerLow
        : colorScheme.surface.withValues(alpha: 0.96);

    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.45)
        : widget.color.withValues(alpha: 0.16);

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.045),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Material(
          color: cardColor,
          borderRadius: BorderRadius.circular(18.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (value) {
              if (_isPressed == value) return;

              setState(() {
                _isPressed = value;
              });
            },
            splashColor: widget.color.withValues(alpha: 0.08),
            highlightColor: widget.color.withValues(alpha: 0.04),
            child: Ink(
              height: 128.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIcon(context),
                  SizedBox(height: 9.h),
                  Text(
                    widget.text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    widget.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 44.r,
      height: 44.r,
      padding: EdgeInsets.all(7.r),
      decoration: BoxDecoration(
        color: widget.color.withValues(alpha: isDark ? 0.16 : 0.10),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: widget.iconImage != null
          ? Image.asset(
              widget.iconImage!,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) {
                return Icon(
                  Icons.widgets_rounded,
                  size: 23.sp,
                  color: widget.color,
                );
              },
            )
          : Icon(
              widget.iconData ?? Icons.widgets_rounded,
              size: 23.sp,
              color: widget.color,
            ),
    );
  }
}
