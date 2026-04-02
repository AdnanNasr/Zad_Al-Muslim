import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondPageOnboarding extends StatelessWidget {
  const SecondPageOnboarding({super.key});

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
                  image: AssetImage('assets/images/hadith_onboarding.png'),
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
                  'الأحاديث والسنة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontFamily: "Cairo",
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'ابحث واستعرض الأحاديث النبوية بسهولة، اختر حسب الكتاب أو الراوي أو الموضوع، واحصل على عرض فوري لدرجة صحة الحديث.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black54,
                    fontFamily: "Cairo",
                    height: 1.6,
                  ),
                ),
                const Spacer(),
                SizedBox(height: 56.h + 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
