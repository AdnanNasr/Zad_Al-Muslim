import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/splash/presentation/pages/onboarding/first_page_onborading.dart';
import 'package:zad_al_muslim/features/splash/presentation/pages/onboarding/second_page_onborading.dart';
import 'package:zad_al_muslim/features/splash/presentation/pages/onboarding/third_page_onborading.dart';
import 'package:zad_al_muslim/features/splash/presentation/pages/onboarding/fourth_page_onboarding.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();

  int _index = 0;

  final int _totalPages = 4;

  List<List<Color>> get _backgrounds => [
    [context.color.primary, const Color(0xFF08171C)],
    [const Color(0xFF123C52), const Color(0xFF07141A)],
    [const Color(0xFF0F5132), const Color(0xFF08130E)],
    [context.color.primary, const Color(0xFF08171C)],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _backgrounds[_index],
          ),
        ),
        child: Stack(
          children: [
            /// زخارف الخلفية
            Positioned(
              top: -100.h,
              right: -80.w,
              child: Container(
                width: 240.w,
                height: 240.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: .04),
                ),
              ),
            ),

            Positioned(
              bottom: 120.h,
              left: -90.w,
              child: Container(
                width: 220.w,
                height: 220.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: .03),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  /// زر التخطي
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedOpacity(
                        opacity: _index < _totalPages - 1 ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: FilledButton.tonal(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: .08,
                            ),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 18.w,
                              vertical: 10.h,
                            ),
                          ),
                          onPressed: _index < _totalPages - 1
                              ? () {
                                  _controller.animateToPage(
                                    _totalPages - 1,
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                          child: Text(
                            'تخطي',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// الصفحات
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (i) {
                        setState(() {
                          _index = i;
                        });
                      },
                      children: const [
                        FirstPageOnboarding(),
                        SecondPageOnboarding(),
                        FourthPageOnboarding(),
                        ThirdPageOnboarding(),
                      ],
                    ),
                  ),

                  /// المؤشرات + الأزرار
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// السابق
                        _index > 0
                            ? TextButton(
                                onPressed: () {
                                  _controller.previousPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Text(
                                  'السابق',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: .9),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              )
                            : SizedBox(width: 70.w),

                        /// المؤشرات
                        _Indicator(index: _index),

                        /// التالي / finish
                        _index < _totalPages - 1
                            ? Material(
                                color: Colors.white,
                                shape: const CircleBorder(),
                                elevation: 6,
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () {
                                    _controller.nextPage(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(14.w),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: context.color.primary,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(width: 70.w),
                      ],
                    ),
                  ),

                  SizedBox(height: 22.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final int index;

  const _Indicator({required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        final bool isActive = i == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          width: isActive ? 26.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: .25),
          ),
        );
      }),
    );
  }
}
