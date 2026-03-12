import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondPageOnboarding extends StatelessWidget {
  const SecondPageOnboarding({super.key});

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
                  image: AssetImage('assets/images/hadith_onboarding.png'),
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
                  'الأحاديث والسنة',
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
                  'ابحث واستعرض الأحاديث النبوية بسهولة، اختر حسب الكتاب أو الراوي أو الموضوع، واحصل على عرض فوري لدرجة صحة الحديث لتجربة دقيقة ومنظمة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black54,
                    height: 1.6,
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
