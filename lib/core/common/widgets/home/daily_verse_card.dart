import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/common/providers/daily_content_provider.dart';
import 'package:zad_al_muslim/core/constants/surah_names.dart';

class DailyVerseCard extends ConsumerStatefulWidget {
  const DailyVerseCard({super.key});

  @override
  ConsumerState<DailyVerseCard> createState() => _DailyVerseCardState();
}

class _DailyVerseCardState extends ConsumerState<DailyVerseCard> {
  bool _showCopiedMessage = false;

  @override
  Widget build(BuildContext context) {
    final verseAsync = ref.watch(dailyVerseProvider);

    return verseAsync.when(
      data: (verse) => _buildCard(context, verse),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> verse) {
    final text = (verse['aya_text_emlaey'] ?? '') as String;
    final int suraNo = verse['sura_no'] ?? 1;
    final surahName = SurahNames.getFormattedName(suraNo);
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
            color: context.color.primary.withValues(alpha: 0.3),
            width: 1.5,
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
            Stack(
              alignment: Alignment.centerRight,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 85.w,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _showCopiedMessage ? 1.0 : 0.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: context.color.primary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "تم النسخ",
                        style: TextStyle(
                          color: context.color.onPrimary,
                          fontSize: 12.sp,
                          fontFamily: "Cairo",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    final shareText =
                        "﴿ $text ﴾\n\n- سورة $surahName، الآية $ayaNo";
                    Clipboard.setData(ClipboardData(text: shareText));
                    _showCopiedMessage = true;
                    setState(() {});
                    if (_showCopiedMessage) {
                      Future.delayed(
                        const Duration(seconds: 1, milliseconds: 500),
                        () {
                          if (mounted) {
                            setState(() => _showCopiedMessage = false);
                          }
                        },
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
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
          ],
        ),
      ),
    );
  }
}
