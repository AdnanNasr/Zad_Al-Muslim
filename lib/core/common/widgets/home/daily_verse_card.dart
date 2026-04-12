import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/common/providers/daily_content_provider.dart';

class DailyVerseCard extends ConsumerWidget {
  const DailyVerseCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verseAsync = ref.watch(dailyVerseProvider);

    return verseAsync.when(
      data: (verse) => _buildCard(context, verse),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> verse) {
    final text = (verse['aya_text_emlaey'] ?? '') as String;
    final surahName = (verse['sura_name_ar'] ?? '') as String;
    final ayaNo = verse['aya_no'] ?? 0;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            colors: isDark
                ? [
                    context.color.primary.withValues(alpha: 0.15),
                    context.color.primary.withValues(alpha: 0.05),
                  ]
                : [
                    context.color.primary.withValues(alpha: 0.08),
                    context.color.primary.withValues(alpha: 0.03),
                  ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          border: Border.all(
            color: context.color.primary.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // العنوان
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_stories_rounded,
                  color: context.color.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  "آية اليوم",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                    color: context.color.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // نص الآية
            Text(
              "﴿ $text ﴾",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.sp,
                fontFamily: "Naskh",
                height: 1.8,
                color: context.color.onSurface,
              ),
            ),
            SizedBox(height: 12.h),

            // اسم السورة ورقم الآية
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: context.color.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                "سورة $surahName - الآية $ayaNo",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.w600,
                  color: context.color.primary,
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // زر النسخ
            InkWell(
              onTap: () {
                final shareText =
                    "﴿ $text ﴾\n\n- سورة $surahName، الآية $ayaNo";
                Clipboard.setData(ClipboardData(text: shareText));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("تم نسخ الآية"),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.copy_rounded,
                      size: 18.sp,
                      color: context.color.primary.withValues(alpha: 0.6),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "نسخ الآية",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: "Cairo",
                        color: context.color.primary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
