import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import '../../domain/entities/tafsser_entities.dart';

class TafsserItem extends StatefulWidget {
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
  State<TafsserItem> createState() => TafsserItemState();
}

class TafsserItemState extends State<TafsserItem> {
  bool isDownloading = false;
  late bool isDownloaded;
  double downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    isDownloaded = widget.isDownloaded;
  }

  @override
  void didUpdateWidget(TafsserItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDownloaded != widget.isDownloaded) {
      setState(() {
        isDownloaded = widget.isDownloaded;
        if (isDownloaded && isDownloading) {
          isDownloading = false;
          downloadProgress = 0.0;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: "عرض المعلومات",
        child: InkWell(
          onTap: widget.onTap,
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
                        widget.info.name,
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
                        widget.info.description,
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
                _buildDownloadButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleDownload() {
    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
    });
    widget.onPressed.call();
  }

  void updateDownloadProgress(double progress) {
    if (mounted) {
      setState(() {
        downloadProgress = progress;
      });
    }
  }

  void setIsDownloading(bool value) {
    if (mounted) {
      setState(() {
        isDownloading = value;
      });
    }
  }

  void markAsDownloaded() {
    if (mounted) {
      setState(() {
        isDownloading = false;
        isDownloaded = true;
      });
    }
  }

  Widget _buildDownloadButton(BuildContext context) {
    final actualDownloaded = isDownloaded || widget.isDownloaded;

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
          color: context.color.primaryContainer.withValues(alpha: 0.5),
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
                value: downloadProgress,
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.color.primary,
                ),
                backgroundColor: context.color.primary.withValues(alpha: 0.2),
              ),
            ),
            Text(
              "${(downloadProgress * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: context.color.primary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: context.color.primaryContainer.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: _handleDownload,
        icon: Icon(
          Icons.cloud_download_rounded,
          size: 22.sp,
          color: context.color.primary,
        ),
      ),
    );
  }
}
