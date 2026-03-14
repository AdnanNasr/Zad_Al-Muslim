import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/features/quran/presentation/widgets/quran_search_sheet.dart';

class QurahPageBottomNavigationBar extends StatefulWidget {
  const QurahPageBottomNavigationBar({super.key});

  @override
  State<QurahPageBottomNavigationBar> createState() =>
      _QurahPageBottomNavigationBarState();
}

class _QurahPageBottomNavigationBarState
    extends State<QurahPageBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _offsetAnimation = Tween<Offset>(begin: Offset(0, 1.2), end: Offset(0, 0))
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.decelerate,
          ),
        );

    _animationController.forward();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.h, left: 24.w, right: 24.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: Container(
              height: 65.h,
              decoration: BoxDecoration(
                color: context.color.primary.withValues(alpha: .9),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: .1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(context, Icons.search_rounded, "بحث", () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      sheetAnimationStyle: AnimationStyle(duration: Duration(milliseconds: 800), curve: Curves.decelerate),
                      constraints: BoxConstraints(
                        // minHeight: context.mediaQueryHeight - 100.h,
                        maxHeight: context.mediaQueryHeight - 100.h,
                      ),
                      context: context,
                      builder: (context) {
                        return QuranSearchSheet();
                      },
                    );
                  }),
                  _buildDivider(context),
                  _buildNavItem(
                    context,
                    Icons.auto_stories_rounded,
                    "الفهرس",
                    () {},
                  ),
                  _buildDivider(context),
                  _buildNavItem(
                    context,
                    Icons.bookmarks_rounded,
                    "العلامات",
                    () {},
                  ),
                  _buildDivider(context),
                  _buildNavItem(
                    context,
                    Icons.settings_rounded,
                    "الإعدادات",
                    () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ويدجت لبناء العناصر بشكل موحد
  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: context.color.onPrimary, size: 24.sp),
              SizedBox(height: 2.h),
              Text(
                label,
                style: TextStyle(
                  color: context.color.onPrimary,
                  fontSize: 10.sp,
                  fontFamily: "Cairo", // تأكد من وجود الخط في مشروعك
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // فاصل أنيق بين الأزرار
  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 25.h,
      width: 1,
      color: context.color.onPrimary.withValues(alpha: .2),
    );
  }
}
