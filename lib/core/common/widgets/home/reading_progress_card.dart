import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/features/quran/data/models/mark.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/mark.dart';

class ReadingProgressCard extends ConsumerWidget {
  const ReadingProgressCard({super.key, this.onTap});

  static const int totalPages = 604;

  /// يمكن تمرير حدث متابعة القراءة من الصفحة الرئيسية لاحقًا.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marks = ref.watch(marksProvder);

    final readingMark = _findReadingMark(marks);

    if (readingMark == null) {
      return const SizedBox.shrink();
    }

    final currentPage = readingMark.pageNumber.clamp(1, totalPages);
    final remainingPages = totalPages - currentPage;
    final progressValue = (currentPage / totalPages).clamp(0.0, 1.0);
    final percentage = progressValue * 100;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.r),
          splashColor: colorScheme.primary.withValues(alpha: 0.08),
          highlightColor: colorScheme.primary.withValues(alpha: 0.04),
          child: Ink(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.45),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CardHeader(percentage: percentage),

                SizedBox(height: 20.h),

                _ProgressIndicator(progress: progressValue),

                SizedBox(height: 14.h),

                _ReadingStatistics(
                  currentPage: currentPage,
                  remainingPages: remainingPages,
                ),

                SizedBox(height: 16.h),

                _MotivationalMessage(progress: progressValue),

                if (onTap != null) ...[
                  SizedBox(height: 16.h),
                  const _ContinueReadingAction(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// نستبعد علامات الآيات ونبحث عن موضع قراءة صالح.
  ///
  /// استخدمنا أعلى رقم صفحة بدل marks.last لأن البيانات المحملة من Isar
  /// ليست مضمونة الترتيب ما لم يتم فرزها صراحة.
  Mark? _findReadingMark(List<Mark> marks) {
    final pageMarks = marks.where((mark) {
      final isPageMark = mark.ayahNumber == null;
      final isValidPage = mark.pageNumber >= 1 && mark.pageNumber <= totalPages;

      return isPageMark && isValidPage;
    }).toList();

    if (pageMarks.isEmpty) return null;

    return pageMarks.reduce((current, next) {
      return next.pageNumber > current.pageNumber ? next : current;
    });
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.percentage});

  final double percentage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 46.r,
          height: 46.r,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Icon(
            Icons.menu_book_rounded,
            size: 24.sp,
            color: colorScheme.primary,
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تقدم القراءة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'رحلتك مع القرآن الكريم',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            '${percentage.toStringAsFixed(1)}%',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 9.h,
            backgroundColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.80,
            ),
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        ),

        SizedBox(height: 7.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'البداية',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'الختمة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReadingStatistics extends StatelessWidget {
  const _ReadingStatistics({
    required this.currentPage,
    required this.remainingPages,
  });

  final int currentPage;
  final int remainingPages;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatisticItem(
            icon: Icons.bookmark_outline_rounded,
            label: 'موضعك الحالي',
            value: 'الصفحة $currentPage',
          ),
        ),

        SizedBox(width: 10.w),

        Expanded(
          child: _StatisticItem(
            icon: Icons.flag_outlined,
            label: 'المتبقي للختمة',
            value: '$remainingPages صفحة',
          ),
        ),
      ],
    );
  }
}

class _StatisticItem extends StatelessWidget {
  const _StatisticItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 19.sp, color: colorScheme.primary),

          SizedBox(width: 8.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
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

class _MotivationalMessage extends StatelessWidget {
  const _MotivationalMessage({required this.progress});

  final double progress;

  String get message {
    if (progress >= 1) {
      return 'ما شاء الله، أتممت رحلتك مع المصحف.';
    }

    if (progress >= 0.75) {
      return 'اقتربت كثيرًا من إتمام الختمة، واصل تقدمك.';
    }

    if (progress >= 0.50) {
      return 'تجاوزت نصف المصحف، بارك الله في استمرارك.';
    }

    if (progress >= 0.25) {
      return 'خطوات ثابتة تصنع وردًا دائمًا.';
    }

    return 'كل صفحة تقرؤها تقربك خطوة جديدة.';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 17.sp,
            color: colorScheme.onTertiaryContainer,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onTertiaryContainer,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueReadingAction extends StatelessWidget {
  const _ContinueReadingAction();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(
          'متابعة القراءة',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        SizedBox(width: 5.w),
        Icon(Icons.arrow_back_rounded, size: 18.sp, color: colorScheme.primary),
      ],
    );
  }
}
