import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageHeader extends StatelessWidget {
  final String tooltip;
  final IconData? icon;
  final String title;
  final String? subTitle;
  const PageHeader({
    super.key,
    required this.tooltip,
    this.icon,
    required this.title,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 8.h),
      child: Row(
        children: [
          IconButton.filledTonal(
            tooltip: tooltip,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
          SizedBox(width: 10.w),
          if (icon != null)
            Container(
              width: 46.r,
              height: 46.r,
              decoration: BoxDecoration(
                color: scheme.secondaryContainer,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(
                icon,
                color: scheme.onSecondaryContainer,
                size: 25.sp,
              ),
            ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                  ),
                ),
                if (subTitle != null)
                  Text(
                    subTitle!,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10.5.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
