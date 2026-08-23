import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondPageOnboarding extends StatelessWidget {
  const SecondPageOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(height: 10.h),

                    /// الصورة
                    Expanded(
                      flex: 6,
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: -6, end: 6),
                        duration: const Duration(seconds: 3),
                        curve: Curves.easeInOut,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, value),
                            child: child,
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            /// دائرة خارجية
                            Container(
                              width: 240.w,
                              height: 240.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: .05),
                              ),
                            ),

                            /// دائرة داخلية
                            Container(
                              width: 190.w,
                              height: 190.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: .03),
                              ),
                            ),

                            /// الصورة
                            Image.asset(
                              'assets/images/hadith_onboarding.png',
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    /// المحتوى
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          /// العنوان
                          Text(
                            'الأحاديث والسنة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Cairo',
                              height: 1.2,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          /// الوصف
                          Text(
                            'ابحث واستعرض الأحاديث النبوية بسهولة، مع إمكانية التصفية حسب الكتاب أو الراوي أو الموضوع، وعرض درجة صحة الحديث بشكل واضح.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white.withValues(alpha: .78),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Cairo',
                              height: 1.9,
                            ),
                          ),

                          SizedBox(height: 16.h),

                          /// بطاقة مميزة
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.r),
                              color: Colors.white.withValues(alpha: .04),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: .08),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44.w,
                                  height: 44.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: .08),
                                  ),
                                  child: Icon(
                                    Icons.menu_book_rounded,
                                    color: Colors.white,
                                    size: 22.sp,
                                  ),
                                ),

                                SizedBox(width: 14.w),

                                Expanded(
                                  child: Text(
                                    'مصدر موثوق لاستكشاف السنة النبوية بشكل منظم وسهل.',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white.withValues(
                                        alpha: .75,
                                      ),
                                      fontFamily: 'Cairo',
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
      },
    );
  }
}
