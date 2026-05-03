import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/mark.dart';

class ReadingProgressCard extends ConsumerWidget {
  const ReadingProgressCard({super.key});

  static const int totalPages = 604;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marks = ref.watch(marksProvder);

    if (marks.isEmpty) return const SizedBox.shrink();

    final lastMark = marks.last;
    final progress = (lastMark.pageNumber).toDouble();

    // if (lastMark.pageNumber == 0) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: context.color.surface,
          border: Border.all(
            color: context.color.primary.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_graph_rounded,
                  color: context.color.primary,
                  size: 22.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  "تقدم ختمتك",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                    color: context.color.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  "${((progress / 604) * 100).toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                    color: context.color.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: progress / 604,
                minHeight: 10.h,
                backgroundColor: context.color.primary.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation(context.color.primary),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "قرأت ${lastMark.pageNumber} صفحة من $totalPages صفحة",
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: "Cairo",
                color: context.color.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
