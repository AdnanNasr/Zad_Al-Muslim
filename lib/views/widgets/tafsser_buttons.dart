import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/extensions/color_ext.dart';

class TafsserItem extends StatelessWidget {
  final TafsserInfo info;
  final void Function() onPressed;
  final VoidCallback? onTap;

  const TafsserItem({
    super.key,
    required this.info,
    this.onTap,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: "عرض المعلومات",
        child: InkWell(
          onTap: onTap,
          splashColor: context.color.primary.withValues(alpha: 0.1),
          highlightColor: context.color.primary.withValues(alpha: 0.05),
          child: Ink(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: context.color.surface,

              border: Border(
                bottom: BorderSide(
                  color: context.color.outlineVariant.withValues(alpha: 0.4),
                  width: 0.8,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        info.name,
                        style: TextStyle(
                          color: context.color.onSurface,
                          fontFamily: "Rubik",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        info.description,
                        style: TextStyle(
                          color: context.color.onSurfaceVariant,
                          fontSize: 14.sp,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10.w),

                _buildDownloadButton(context, onPressed: onPressed),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton(
    BuildContext context, {
    required void Function() onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.color.primaryContainer.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          Icons.cloud_download_rounded,
          size: 22.sp,
          color: context.color.primary,
        ),
        constraints: BoxConstraints.tightFor(width: 40.w, height: 40.w),
        splashRadius: 24.w,
        tooltip: 'تحميل التفسير',
      ),
    );
  }
}

class TafsserInfo {
  final String name;
  final String description;
  final String id;

  TafsserInfo({required this.name, required this.description, required this.id});
}
