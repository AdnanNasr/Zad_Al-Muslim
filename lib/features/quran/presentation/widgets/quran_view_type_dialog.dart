import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/features/quran/presentation/providers/quran_settings_provider.dart';

class QuranViewTypeDialog extends ConsumerWidget {
  const QuranViewTypeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(quranSettingsProvider);
    final selectedType = settings.quranViewType;

    final List<Map<String, dynamic>> viewOptions = [
      {
        'label': 'الشكل الثابت',
        'description': 'عرض الصفحة بحجم ثابت لا يتغيّر',
        'icon': Icons.crop_square_rounded,
        'value': QuranViewType.fixed,
      },
      {
        'label': 'الشكل القابل للتكبير والتصغير',
        'description': 'قابل للتكبير والتصغير بإصبعين',
        'icon': Icons.zoom_in_rounded,
        'value': QuranViewType.zoomable,
      },
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
                    Icons.view_quilt_rounded,
                    color: context.color.primary,
                    size: 24.sp,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'طريقة عرض الصفحة',
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

            // الخيارات
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewOptions.length,
              itemBuilder: (context, index) {
                final option = viewOptions[index];
                final isSelected = option['value'] == selectedType;

                return InkWell(
                  onTap: () {
                    ref
                        .read(quranSettingsProvider.notifier)
                        .setQuranViewType(option['value']);
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
                      vertical: 14.h,
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
                        // أيقونة الخيار
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? context.color.primary.withValues(alpha: .15)
                                : context.color.onSurface.withValues(
                                    alpha: .06,
                                  ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            option['icon'] as IconData,
                            color: isSelected
                                ? context.color.primary
                                : context.color.onSurface.withValues(
                                    alpha: .45,
                                  ),
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        // النص
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option['label'] as String,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? context.color.primary
                                      : context.color.onSurface,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                option['description'] as String,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11.sp,
                                  color: context.color.onSurface.withValues(
                                    alpha: .5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // مؤشر الاختيار
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
                      ],
                    ),
                  ),
                );
              },
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
