import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/view_models/logic/onboarding_storage.dart';

class ThirdPageOnboarding extends StatelessWidget {
  const ThirdPageOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: 300.w,
              height: 250.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/kaaba.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  'أوقات الصلاة واتجاه القبلة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontFamily: "Cairo",
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'تابع أوقات الصلاة بدقة، وحدد اتجاه القبلة بسهولة، مع إمكانية حفظ الأذكار والأحاديث المفضلة للوصول السريع في أي وقت.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black54,
                    height: 1.6.h,
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: 250.w,
                  height: 55.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () async {
                      await OnboardingStorage.markAsSeen();
                      if (!context.mounted) return;
                      Navigator.pushReplacementNamed(context, '/custom_navigation_bar');
                    },
                    child: Text(
                      'ابدأ الاستخدام الآن',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Cairo",
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
