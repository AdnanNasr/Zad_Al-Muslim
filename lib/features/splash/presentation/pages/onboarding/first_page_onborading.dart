import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstPageOnboarding extends StatelessWidget {
  const FirstPageOnboarding({super.key});

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
                  image: AssetImage('assets/images/quran_onboarding.png'),
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
                  'القرآن الكريم',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'استكشف آيات القرآن الكريم بسهولة ويسر، مع إمكانية البحث والتنقل بين السور والآيات بطريقة منظمة لتسهيل قراءتك اليومية.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black54,
                    fontFamily: "Cairo",
                    height: 1.6,
                  ),
                ),
                const Spacer(),
                // ترك مساحة فارغة توازي حجم الزر في الصفحة الأخيرة لثبات التصميم
                SizedBox(height: 56.h + 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
