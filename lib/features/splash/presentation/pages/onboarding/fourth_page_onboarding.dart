import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FourthPageOnboarding extends StatelessWidget {
  const FourthPageOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        children: [
          SizedBox(height: 10.h),

          /// الصورة (نفس نمط باقي الصفحات)
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

                  /// أيقونة
                  Image.asset(
                    'assets/images/quran_moratal.png',
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),

          // SizedBox(height: 8.h),

          /// المحتوى النصي (بدون overflow)
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// العنوان
                Text(
                  'الاستماع إلى تلاوات القرآن',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    // height: 1.2,
                  ),
                ),

                SizedBox(height: 12.h),

                /// الوصف
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    'استمع إلى القرآن الكريم بأصوات نخبة من القراء، مع إمكانية اختيار القارئ المفضل لديك وتجربة روحانية هادئة في أي وقت.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white.withValues(alpha: .78),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Cairo',
                      height: 1.9,
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                /// البطاقة السفلية
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
                      /// الأيقونة
                      Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: .08),
                        ),
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),

                      SizedBox(width: 14.w),
                      Flexible(
                        child: Text(
                          'اختر القارئ واستمتع بتلاوة خاشعة عالية الجودة.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white.withValues(alpha: .75),
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
    );
  }
}
