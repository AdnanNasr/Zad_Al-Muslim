import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/constants/enums/qrai_names_ayah_by_ayah.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/features/quran/presentation/providers/audio_player_provider.dart';
import 'package:noor_quran/features/quran/presentation/providers/quran_settings_provider.dart';

class SelectQariDialog extends ConsumerWidget {
  const SelectQariDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedQari = ref.watch(selectedQariProvider);
    const qariList = QariNamesAyahByAyah.allQaris;

    return Dialog(
      backgroundColor: context.color.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- العنوان ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Hero(
                    tag: "qari_icon",
                    child: Icon(
                      Icons.spatial_audio_off,
                      color: context.color.primary,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'اختيار القارئ',
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

            // --- قائمة القراء ---
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: qariList.length,
                itemBuilder: (context, index) {
                  final qari = qariList[index];
                  final isSelected = qari.id == selectedQari.id;

                  return InkWell(
                    onTap: () {
                      ref
                          .read(quranSettingsProvider.notifier)
                          .setSelectedQari(qari);
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
                          // أيقونة الحالة
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

                          // اسم القارئ
                          Expanded(
                            child: Text(
                              qari.name,
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

            // --- زر الإلغاء ---
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
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
