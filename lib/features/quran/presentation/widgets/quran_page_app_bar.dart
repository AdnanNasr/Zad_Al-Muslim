import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/constants/surah_names.dart';
import 'package:zad_al_muslim/core/constants/routes.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:qcf_quran/qcf_quran.dart';

class QuranPageAppBar extends ConsumerStatefulWidget {
  final String surahName;
  final int juzzNumber;
  final String placeOfRevelation;
  final int verseCount;
  const QuranPageAppBar({
    super.key,
    this.surahName = "اسم السورة",
    this.juzzNumber = 1,
    this.placeOfRevelation = "مكية",
    this.verseCount = 7,
  });

  @override
  ConsumerState<QuranPageAppBar> createState() => _QuranPageAppBarState();
}

class _QuranPageAppBarState extends ConsumerState<QuranPageAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // أبطأ قليلاً لزيادة الفخامة
    );

    _offsetAnimation =
        Tween<Offset>(
          begin: const Offset(0, -1.2), // يبدأ من خارج الشاشة تماماً
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.decelerate, // تأثير ارتداد خفيف عند الدخول
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Container(
            decoration: BoxDecoration(
              color: context.color.surface.withValues(alpha: .96),
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(color: context.color.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: context.color.shadow.withValues(alpha: .10),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              children: [
                // زر العودة بتنسيق متناسق
                _buildSquareAction(
                  message: "الصفحة الرئيسية",
                  icon: Icons.arrow_back_ios_rounded,
                  onTap: () => Navigator.of(
                    context,
                  ).popUntil(ModalRoute.withName(Routes.customNavigationBar)),
                ),

                SizedBox(width: 16.w),

                // النصوص المركزية
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "سورة ${widget.surahName}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.sp,
                          color: context.color.onSurface,
                          fontFamily: "Cairo",
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        spacing: 16.w,
                        children: [
                          Text(
                            "الجزء ${widget.juzzNumber}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: "Cairo",
                              color: context.color.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "عدد الآيات ${widget.verseCount}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: "Cairo",
                              color: context.color.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ويدجت موحدة للأزرار الجانبية المربعة
  Widget _buildSquareAction({
    required IconData icon,
    required VoidCallback onTap,
    required String message,
  }) {
    return Tooltip(
      message: message,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(10.dg),
            decoration: BoxDecoration(
              color: context.color.tertiaryContainer,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: context.color.onTertiaryContainer,
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class AppAndBottomBar extends StatelessWidget {
  const AppAndBottomBar({
    super.key,
    required this.globalSurahNumber,
    required this.globalStartOfSurah,
  });

  final int globalSurahNumber;
  final int globalStartOfSurah;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: QuranPageAppBar(
        surahName: SurahNames.getFormattedName(globalSurahNumber),
        juzzNumber: getJuzNumber(globalSurahNumber, globalStartOfSurah),
        placeOfRevelation: getPlaceOfRevelation(globalSurahNumber),
        verseCount: getVerseCount(globalSurahNumber),
      ),
    );
  }
}
