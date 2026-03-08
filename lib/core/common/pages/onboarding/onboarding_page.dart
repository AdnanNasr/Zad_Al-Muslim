import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/common/pages/onboarding/first_page_onborading.dart';
import 'package:noor_quran/core/common/pages/onboarding/second_page_onborading.dart';
import 'package:noor_quran/core/common/pages/onboarding/third_page_onborading.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // زر تخطي
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Align(
                alignment: Alignment.centerRight,
                child: AnimatedOpacity(
                  opacity: _index < 2 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: TextButton(
                    onPressed: _index < 2
                        ? () {
                            _controller.animateToPage(
                              2,
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.fastOutSlowIn,
                            );
                          }
                        : null,
                    child: Text(
                      'تخطي',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                physics: const BouncingScrollPhysics(),
                children: const [
                  FirstPageOnboarding(),
                  SecondPageOnboarding(),
                  ThirdPageOnboarding(),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                              color: Theme.of(context).primaryColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Cairo",
                            ),
                          ),
                        )
                      : SizedBox(width: 60.w),
                  _Indicator(index: _index),
                  _index < 2
                      ? Material(
                          color: Theme.of(context).primaryColor,
                          shape: const CircleBorder(),
                          elevation: 4,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(width: 60.w),
                ],
              ),
            ),
            SizedBox(height: 20.h),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final bool isActive = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          width: isActive ? 24.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColor.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}
