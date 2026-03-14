import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/constants/routes.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/features/quran/presentation/widgets/quran_more_menu.dart';

class QuranPageAppBar extends StatefulWidget {
  final String surahName; // أضفت هذا ليكون الكود تفاعلياً
  final int juzzNumber;
  const QuranPageAppBar({
    super.key, 
    this.surahName = "اسم السورة", 
    this.juzzNumber = 1
  });

  @override
  State<QuranPageAppBar> createState() => _QuranPageAppBarState();
}

class _QuranPageAppBarState extends State<QuranPageAppBar>
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

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2), // يبدأ من خارج الشاشة تماماً
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate, // تأثير ارتداد خفيف عند الدخول
    ));

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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  // تدرج لوني خفيف لزيادة العمق
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.color.primary.withValues(alpha: .9),
                      context.color.primary.withValues(alpha: .8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .15),
                    width: 1.2,
                  ),
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
                      onTap: () => Navigator.of(context).pushReplacementNamed(Routes.customNavigationBar),
                    ),
                    
                    SizedBox(width: 16.w),
                    
                    // أيقونة الكتاب مع خلفية دائرية خفيفة
                    Container(
                      padding: EdgeInsets.all(8.dg),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.menu_book_rounded, color: Colors.white, size: 22.sp),
                    ),
                    
                    SizedBox(width: 12.w),
                    
                    // النصوص المركزية
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.surahName,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 17.sp,
                              color: Colors.white,
                              fontFamily: "Cairo",
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'الجزء ${widget.juzzNumber}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.white.withValues(alpha: .7),
                              fontFamily: "Cairo",
                            ),
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
                          backgroundColor: Colors.transparent, // لجعل القائمة زجاجية أيضاً
                          builder: (context) => QuranMoreMenu(menuItems: [
                            MenuItem(
                              icon: Icons.widgets_rounded, 
                              label: "لوحة التحكم", 
                              backgroundColor: Colors.blueAccent, 
                              onTap: (){}
                            ),
                          ]),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ويدجت موحدة للأزرار الجانبية المربعة
  Widget _buildSquareAction({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(10.dg),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}