import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';
import 'package:noor_quran/core/constants/routes.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/features/quran/presentation/widgets/quran_more_menu.dart';

class QuranPageAppBar extends ConsumerStatefulWidget {
  final String surahName; // أضفت هذا ليكون الكود تفاعلياً
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
    final themeMode = ref.watch(themeProvider);
    return SlideTransition(
      position: _offsetAnimation,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Container(
            decoration: BoxDecoration(
              color: context.color.primary,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: context.color.primary, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .15),
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
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.of(
                    context,
                  ).pushReplacementNamed(Routes.customNavigationBar),
                  themeMode: themeMode,
                ),

                SizedBox(width: 16.w),

                // النصوص المركزية
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          // TODO
                          "سورة ${widget.surahName}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.sp,
                            color: context.color.onPrimary,
                            fontFamily: "Cairo",
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        spacing: 16.w,
                        children: [
                          Text(
                            'الجزء ${widget.juzzNumber}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: context.color.onPrimary,
                              fontFamily: "Cairo",
                            ),
                          ),
                          Text(
                            // TODO
                            "مكان النزول: ${widget.placeOfRevelation == "Makkah" ? "مكية" : "مدنية"}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              color: context.color.onPrimary,
                              fontFamily: "Cairo",
                            ),
                          ),
                          Text(
                            "${widget.verseCount} آيات",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              color: context.color.onPrimary,
                              fontFamily: "Cairo",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // زر المزيد بتنسيق متناسق
                _buildSquareAction(
                  icon: Icons.more_vert_rounded,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor:
                          Colors.transparent, // لجعل القائمة زجاجية أيضاً
                      builder: (context) => QuranMoreMenu(
                        menuItems: [
                          MenuItem(
                            icon: Icons.widgets_rounded,
                            label: "لوحة التحكم",
                            backgroundColor: Colors.blueAccent,
                            onTap: () {},
                          ),
                        ],
                      ),
                    );
                  },
                  themeMode: themeMode,
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
    required ThemeMode themeMode,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(10.dg),
          decoration: BoxDecoration(
            color: context.color.onPrimary.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: context.color.onPrimary, size: 20.sp),
        ),
      ),
    );
  }
}
