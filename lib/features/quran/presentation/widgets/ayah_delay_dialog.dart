import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/quran_settings_provider.dart';

class AyahDelayDialog extends ConsumerWidget {
  const AyahDelayDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(quranSettingsProvider);
    final selectedDelay = settings.ayahDelaySeconds;

    final List<Map<String, dynamic>> delayOptions = [
      {'label': 'بدون توقف', 'value': 0},
      {'label': 'ثانية واحدة', 'value': 1},
      {'label': 'ثانيتين', 'value': 2},
      {'label': '3 ثوانٍ', 'value': 3},
      {'label': '4 ثوانٍ', 'value': 4},
      {'label': '5 ثوانٍ', 'value': 5},
    ];

    return Dialog(
      backgroundColor: context.color.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // العنوان
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_rounded,
                    color: context.color.primary,
                    size: 24.sp,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'الفاصل الزمني بين الآيات',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: context.color.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8.h),
            Divider(color: context.color.onSurface.withValues(alpha: .1)),
            SizedBox(height: 4.h),

            // القائمة
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: delayOptions.length,
                itemBuilder: (context, index) {
                  final option = delayOptions[index];
                  final isSelected = option['value'] == selectedDelay;

                  return InkWell(
                    onTap: () {
                      ref
                          .read(quranSettingsProvider.notifier)
                          .setAyahDelay(option['value']);
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.color.primary.withValues(alpha: .12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.r),
                        border: isSelected
                            ? Border.all(
                                color: context.color.primary.withValues(
                                  alpha: .4,
                                ),
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: isSelected
                                ? Icon(
                                    Icons.check_circle_rounded,
                                    key: const ValueKey('selected'),
                                    color: context.color.primary,
                                    size: 22.sp,
                                  )
                                : Icon(
                                    Icons.radio_button_unchecked_rounded,
                                    key: const ValueKey('unselected'),
                                    color: context.color.onSurface.withValues(
                                      alpha: .3,
                                    ),
                                    size: 22.sp,
                                  ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Text(
                              option['label'],
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 15.sp,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? context.color.primary
                                    : context.color.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 8.h),
            Divider(color: context.color.onSurface.withValues(alpha: .1)),

            // زر الإلغاء
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14.sp,
                  color: context.color.onSurface.withValues(alpha: .6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
