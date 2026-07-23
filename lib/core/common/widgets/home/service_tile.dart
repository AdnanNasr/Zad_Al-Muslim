import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceTile extends StatelessWidget {
  const ServiceTile({
    super.key,
    required this.width,
    required this.title,
    required this.subtitle,
    required this.actionName,
    required this.iconImage,
    required this.accentColor,
    required this.onTap,
  });

  final double width;
  final String title;
  final String subtitle;
  final String actionName;
  final String iconImage;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: '$title، $subtitle',
      child: SizedBox(
        width: width,
        child: Material(
          color: scheme.surface,
          elevation: isDark ? 0 : 2.5,
          shadowColor: Colors.black.withValues(alpha: .16),
          borderRadius: BorderRadius.circular(18.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Ink(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: isDark
                      ? accentColor.withValues(alpha: 0.16)
                      : scheme.outline.withValues(alpha: 0.32),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42.r,
                    height: 42.r,
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.11),
                      borderRadius: BorderRadius.circular(13.r),
                    ),
                    child: Image.asset(
                      iconImage,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.widgets_rounded,
                        color: accentColor,
                        size: 22.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 11.h),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: scheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(actionName, style: const TextStyle()),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18.sp,
                        color: accentColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
