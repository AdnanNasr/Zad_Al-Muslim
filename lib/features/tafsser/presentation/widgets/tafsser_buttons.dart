import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import '../../domain/entities/tafsser_entities.dart';
import '../providers/tafsser_download_provider.dart';

class TafsserItem extends ConsumerWidget {
  final TafsserBookEntity info;
  final void Function() onPressed;
  final VoidCallback? onTap;
  final bool isDownloaded;

  const TafsserItem({
    super.key,
    required this.info,
    this.onTap,
    required this.onPressed,
    this.isDownloaded = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadState = ref.watch(
      tafsserDownloadProvider.select((map) => map[info.id]),
    );
    final isDownloading = downloadState?.isDownloading ?? false;
    final downloadProgress = downloadState?.progress ?? 0.0;

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
                          fontFamily: "Cairo",
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
                _buildDownloadButton(
                  context,
                  isDownloaded,
                  isDownloading,
                  downloadProgress,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton(
    BuildContext context,
    bool actualDownloaded,
    bool isDownloading,
    double downloadProgress,
  ) {
    if (actualDownloaded) {
      return Container(
        decoration: BoxDecoration(
          color: context.color.primary.withValues(alpha: .3),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: null,
          icon: Icon(
            Icons.check_circle_rounded,
            size: 22.sp,
            color: context.color.primary,
          ),
        ),
      );
    }

    if (isDownloading) {
      return Container(
        decoration: BoxDecoration(
          color: context.color.primary.withValues(alpha: .3),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(8.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 40.w,
              height: 40.w,
              child: CircularProgressIndicator(
                value: downloadProgress < 0 ? null : downloadProgress,
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.color.primary,
                ),
                backgroundColor: context.color.primary.withValues(alpha: 0.2),
              ),
            ),
            if (downloadProgress >= 0)
              Text(
                "${(downloadProgress * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: context.color.onSurface,
                ),
              ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: context.color.primary.withValues(alpha: .3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          Icons.cloud_download_rounded,
          size: 22.sp,
          color: context.color.primary,
        ),
      ),
    );
  }
}
