import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/features/adkar/domain/entities/adkar_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/features/settings/presentation/providers/app_settings_provider.dart';
import 'package:flutter/services.dart';

class AdkarDetailsPage extends ConsumerWidget {
  final AdkarEntity adkarEntity;

  const AdkarDetailsPage({super.key, required this.adkarEntity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        title: adkarEntity.category,
        center: true,
        profile: false,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: adkarEntity.text.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          return DhikrCard(
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
    );
  }
}

class DhikrCard extends ConsumerStatefulWidget {
  final String text;
  final String footnote;
  final int index;
  final int initialCount;

  const DhikrCard({
    super.key,
    required this.text,
    required this.footnote,
    required this.index,
    required this.initialCount,
  });

  @override
  ConsumerState<DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends ConsumerState<DhikrCard> {
  late int _remainingCount;

  @override
  void initState() {
    super.initState();
    _remainingCount = widget.initialCount;
  }

  void _decrement() {
    if (_remainingCount > 0) {
      if (ref.read(appSettingsProvider).hapticFeedbackEnabled) {
        HapticFeedback.lightImpact();
      }
      setState(() {
        _remainingCount--;
      });
    }
  }

  void _reset() {
    setState(() {
      _remainingCount = widget.initialCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isFinished = _remainingCount == 0;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: BorderSide(
          color: isFinished
              ? Colors.green.withValues(alpha: 0.3)
              : context.color.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      color: isFinished
          ? context.color.primary.withValues(alpha: 0.02)
          : context.color.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDetailsDialog(context),
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
                      color: context.color.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Text(
                      'ذكر رقم ${widget.index}',
                      style: TextStyle(
                        color: context.color.primary,
                        fontFamily: 'Cairo',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (widget.footnote.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: context.color.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: context.color.primary,
                        size: 18.sp,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20.h),

              // Dhikr Text
              Text(
                widget.text,
                textAlign: TextAlign.justify,
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
                  IconButton(
                    onPressed: _reset,
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: context.color.onSurface.withValues(alpha: 0.3),
                    ),
                    tooltip: 'إعادة',
                  ),

                  // Tasbeeh Button
                  GestureDetector(
                    onTap: _decrement,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: isFinished
                            ? Colors.green.shade800
                            : context.color.primary,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isFinished
                                ? Icons.check_circle_rounded
                                : Icons.touch_app_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            isFinished ? 'اكتمل' : '$_remainingCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
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

  void _showDetailsDialog(BuildContext context) {
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
                    color: context.color.surface,
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
                          color: context.color.primary,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Divider(
                        color: context.color.primary.withValues(alpha: 0.05),
                      ),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: EdgeInsets.all(24.w),
                          children: [
                            SelectableText(
                              widget.text,
                              textAlign: TextAlign.justify,
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
                            if (widget.footnote.isNotEmpty) ...[
                              SizedBox(height: 32.h),
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: context.color.primary.withValues(
                                    alpha: 0.05,
                                  ),
                                  borderRadius: BorderRadius.circular(15.r),
                                  border: Border.all(
                                    color: context.color.primary.withValues(
                                      alpha: 0.1,
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
                                          color: context.color.primary,
                                          size: 20.sp,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'تخريج الحديث / ملاحظة',
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                            color: context.color.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    SelectableText(
                                      widget.footnote,
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
