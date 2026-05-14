import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark
        ? widget.color.withValues(alpha: 0.08)
        : widget.color.withValues(alpha: 0.1);

    final contentColor = isDark
        ? (widget.color is MaterialColor
              ? (widget.color as MaterialColor).shade200
              : widget.color)
        : (widget.color is MaterialColor
              ? (widget.color as MaterialColor).shade900
              : widget.color);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: widget.color.withValues(alpha: isDark ? 0.05 : 0.1),
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(20.r),
              child: Ink(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : widget.color.withValues(alpha: 0.2),
                    width: 1.2,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 12,
                      left: 5,
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: 40.sp,
                        color: contentColor.withValues(
                          alpha: isDark ? 0.08 : 0.12,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Row(
                        children: [
                          if (widget.iconImage != null ||
                              widget.iconData != null)
                            Container(
                              width: 40.r,
                              height: 40.r,
                              padding: EdgeInsets.all(2.r),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: contentColor.withValues(alpha: 0.1),
                                ),
                              ),
                              child: widget.iconImage != null
                                  ? Image.asset(widget.iconImage!)
                                  : Icon(
                                      widget.iconData,
                                      color: contentColor,
                                      size: 24.sp,
                                    ),
                            ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.text,
                                  style: TextStyle(
                                    color: contentColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Cairo",
                                    fontSize: 15.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  widget.description,
                                  style: TextStyle(
                                    color: contentColor.withValues(alpha: 0.7),
                                    fontFamily: "Cairo",
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
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
          ),
        ),
      ),
    );
  }
}
