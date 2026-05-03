import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/splash/presentation/pages/onboarding/onboarding_init.dart';

class ThirdPageOnboarding extends StatelessWidget {
  const ThirdPageOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.only(top: 40.h),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/kaaba.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  'أوقات الصلاة والقبلة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: context.color.primary,
                    fontFamily: "Cairo",
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'تابع أوقات الصلاة بدقة، وحدد اتجاه القبلة بسهولة، مع إمكانية حفظ الأذكار والأحاديث المفضلة للوصول السريع في أي وقت.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black54,
                    fontFamily: "Cairo",
                    height: 1.6,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.color.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      await OnboardingInit.markAsSeen();
                      if (!context.mounted) return;
                      Navigator.pushReplacementNamed(
                        context,
                        '/custom_navigation_bar',
                      );
                    },
                    child: Text(
                      'ابدأ الاستخدام الآن',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Cairo",
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
