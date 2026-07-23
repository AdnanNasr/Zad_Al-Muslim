import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/adkar/domain/entities/adkar_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/features/settings/presentation/providers/app_settings_provider.dart';
import 'package:zad_al_muslim/features/adkar/presentation/providers/dhikr_state_provider.dart';
import 'package:flutter/services.dart';

class AdkarDetailsPage extends ConsumerWidget {
  final AdkarEntity adkarEntity;

  const AdkarDetailsPage({super.key, required this.adkarEntity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.color.surfaceContainerLowest,
      body: SafeArea(
        child: Column(
          children: [
            _DetailsHeader(
              title: adkarEntity.category,
              count: adkarEntity.text.length,
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 28.h),
                itemCount: adkarEntity.text.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  return DhikrCard(
                    category: adkarEntity.category,
                    text: adkarEntity.text[index],
                    footnote: index < adkarEntity.footnote.length
                        ? adkarEntity.footnote[index]
                        : '',
                    index: index + 1,
                    initialCount: index < adkarEntity.counts.length
                        ? adkarEntity.counts[index]
                        : 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsHeader extends StatelessWidget {
  const _DetailsHeader({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 8.h),
      child: Row(
        children: [
          IconButton.filledTonal(
            tooltip: 'العودة',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          SizedBox(width: 10.w),
          Container(
            width: 46.r,
            height: 46.r,
            decoration: BoxDecoration(
              color: scheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              color: scheme.onTertiaryContainer,
              size: 23.sp,
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '$count من الأذكار والأدعية',
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

class DhikrCard extends ConsumerWidget {
  final String category;
  final String text;
  final String footnote;
  final int index;
  final int initialCount;

  const DhikrCard({
    super.key,
    required this.category,
    required this.text,
    required this.footnote,
    required this.index,
    required this.initialCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = DhikrStateParams(
      dhikrId: '${category}_$index',
      initialCount: initialCount,
    );

    final remainingCount = ref.watch(dhikrStateProvider(params));
    bool isFinished = remainingCount == 0;

    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: BorderSide(
          color: isFinished
              ? scheme.tertiary.withValues(alpha: 0.38)
              : scheme.outlineVariant,
        ),
      ),
      color: isFinished
          ? scheme.tertiaryContainer.withValues(alpha: 0.32)
          : scheme.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDetailsDialog(context, ref),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Text(
                      'ذكر رقم $index',
                      style: TextStyle(
                        color: scheme.onTertiaryContainer,
                        fontFamily: 'Cairo',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (footnote.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHigh,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: scheme.tertiary,
                        size: 18.sp,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20.h),

              // Dhikr Text
              Text(
                text,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Naskh',
                  fontSize: ref.watch(appSettingsProvider).adkarFontSize.sp,
                  height: 1.6,
                  color: context.color.onSurface,
                ),
              ),

              SizedBox(height: 24.h),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Reset button
                  IconButton.filledTonal(
                    onPressed: () {
                      ref.read(dhikrStateProvider(params).notifier).reset();
                    },
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: scheme.onSurfaceVariant,
                    ),
                    tooltip: 'إعادة',
                  ),

                  // Tasbeeh Button
                  Semantics(
                    button: true,
                    label: isFinished
                        ? 'اكتمل الذكر'
                        : 'متبقي $remainingCount تكرار',
                    child: GestureDetector(
                      onTap: () {
                        if (remainingCount > 0) {
                          if (ref
                              .read(appSettingsProvider)
                              .hapticFeedbackEnabled) {
                            HapticFeedback.lightImpact();
                          }
                          ref
                              .read(dhikrStateProvider(params).notifier)
                              .decrement();
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: isFinished ? scheme.tertiary : scheme.primary,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isFinished
                                  ? Icons.check_circle_rounded
                                  : Icons.touch_app_rounded,
                              color: isFinished
                                  ? scheme.onTertiary
                                  : scheme.onPrimary,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              isFinished ? 'اكتمل' : '$remainingCount',
                              style: TextStyle(
                                color: isFinished
                                    ? scheme.onTertiary
                                    : scheme.onPrimary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 48.w), // Balance for centering
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: context.color.surfaceContainerLow,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),
                      Container(
                        width: 50.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: context.color.onSurface.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'تفاصيل الذكر',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: context.color.tertiary,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Divider(color: context.color.outlineVariant),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: EdgeInsets.all(24.w),
                          children: [
                            Text(
                              text,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: 'Naskh',
                                fontSize:
                                    ref
                                        .watch(appSettingsProvider)
                                        .adkarFontSize
                                        .sp +
                                    2.sp,
                                height: 1.8,
                                color: context.color.onSurface,
                              ),
                            ),
                            if (footnote.isNotEmpty) ...[
                              SizedBox(height: 32.h),
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: context.color.tertiaryContainer
                                      .withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(15.r),
                                  border: Border.all(
                                    color: context.color.tertiary.withValues(
                                      alpha: 0.22,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline_rounded,
                                          color: context.color.tertiary,
                                          size: 20.sp,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'تخريج الحديث / ملاحظة',
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                            color: context
                                                .color
                                                .onTertiaryContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    SelectableText(
                                      footnote,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 14.sp,
                                        height: 1.6,
                                        color: context.color.onSurface
                                            .withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
