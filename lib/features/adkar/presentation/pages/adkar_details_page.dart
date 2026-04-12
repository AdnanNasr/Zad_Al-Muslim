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
    return Stack(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: BorderSide(
              color: context.color.primary.withValues(alpha: .1),
            ),
          ),
          child: InkWell(
            onTap: _decrement,
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Naskh',
                      fontSize: ref.watch(appSettingsProvider).adkarFontSize.sp,
                      height: 1.6,
                      color: context.color.onSurface,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'انقر على البطاقة للتسبيح',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12.sp,
                      color: context.color.primary.withValues(alpha: .4),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Divider(color: context.color.primary.withValues(alpha: .05)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.footnote.isNotEmpty)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 35.w,
                              height: 35.w,
                              decoration: BoxDecoration(
                                color: context.color.primary.withValues(
                                  alpha: .1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  widget.index.toString(),
                                  style: TextStyle(
                                    color: context.color.primary,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'الرقم',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: context.color.onSurface.withValues(
                                  alpha: .4,
                                ),
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        )
                      else
                        const SizedBox.shrink(),

                      _buildCounter(context),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              Icons.refresh_rounded,
                              color: context.color.primary.withValues(
                                alpha: .6,
                              ),
                              size: 24.sp,
                            ),
                            onPressed: _reset,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'إعادة',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: context.color.onSurface.withValues(
                                alpha: .4,
                              ),
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 1.h,
          right: 1.w,
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.h, left: 8.w),
            child: IconButton(
              onPressed: () {
                _showFootnoteDialog(context, widget.footnote);
              },
              icon: Icon(Icons.info_outline_rounded),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCounter(BuildContext context) {
    bool isFinished = _remainingCount == 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isFinished ? Colors.green : context.color.primary,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Text(
            isFinished ? 'تم الأكمال' : 'المتبقي: $_remainingCount',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          isFinished ? 'انتهيت' : 'عدد التكرار',
          style: TextStyle(
            fontSize: 10.sp,
            color: context.color.onSurface.withValues(alpha: .4),
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  void _showFootnoteDialog(BuildContext context, String footnote) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.4,
            maxChildSize: 0.75,
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
                          color: context.color.onSurface.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        'تخريج الحديث / ملاحظة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: context.color.primary,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Divider(
                        color: context.color.primary.withValues(alpha: .05),
                      ),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: EdgeInsets.all(24.w),
                          children: [
                            SelectableText(
                              footnote,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16.sp,
                                height: 1.7,
                                color: context.color.onSurface.withValues(
                                  alpha: .8,
                                ),
                              ),
                            ),
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
