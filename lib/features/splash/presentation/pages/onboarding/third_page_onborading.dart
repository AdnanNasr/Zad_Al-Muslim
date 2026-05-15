import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/utils/notifications/notification_permission_service.dart';
import 'package:zad_al_muslim/features/splash/presentation/pages/onboarding/onboarding_init.dart';

class ThirdPageOnboarding extends StatelessWidget {
  const ThirdPageOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        children: [
          /// المحتوى الرئيسي
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    /// الصورة
                    TweenAnimationBuilder(
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
                          Container(
                            width: 240.w,
                            height: 240.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: .05),
                            ),
                          ),
                          Container(
                            width: 190.w,
                            height: 190.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: .03),
                            ),
                          ),
                          Image.asset(
                            'assets/images/kaaba.png',
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h),

                    /// العنوان
                    Text(
                      'أوقات الصلاة والقبلة',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),

                    SizedBox(height: 10.h),

                    /// الوصف
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.w),
                      child: Text(
                        'تابع أوقات الصلاة بدقة، وحدد اتجاه القبلة بسهولة، مع إمكانية حفظ الأذكار والأحاديث المفضلة للوصول السريع في أي وقت.',
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white.withValues(alpha: .78),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Cairo',
                          height: 1.7,
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),

                    /// بطاقة
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
                            width: 42.w,
                            height: 42.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: .08),
                            ),
                            child: Icon(
                              Icons.explore_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),

                          SizedBox(width: 12.w),

                          Expanded(
                            child: Text(
                              'كل ما تحتاجه لتنظيم عبادتك في مكان واحد.',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white.withValues(alpha: .75),
                                fontFamily: 'Cairo',
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          /// زر ثابت (CTA)
          SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 8,
                ),
                onPressed: () async {
                  await OnboardingInit.markAsSeen();

                  await NotificationPermissionService.request();

                  if (!context.mounted) return;

                  Navigator.pushReplacementNamed(
                    context,
                    '/custom_navigation_bar',
                  );
                },
                child: Text(
                  'ابدأ الاستخدام الآن',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
