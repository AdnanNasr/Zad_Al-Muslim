import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/core/utils/location/providers/location_status_provider.dart';
import 'package:noor_quran/core/common/providers/user_position_provider.dart';
import 'package:noor_quran/core/constants/enums/my_enums.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/core/utils/log/app_logger.dart';
import 'package:noor_quran/features/pray_time/presentation/providers/pray_times_notifier.dart';
import 'package:noor_quran/features/hadith/data/repositories/insert_hadith.dart';
import 'package:noor_quran/features/quran/data/repositories/insert_quran_pages.dart';
import 'package:noor_quran/features/tafsser/data/repositories/insert_tafsser.dart';
import 'package:noor_quran/core/utils/location/location_locator.dart';
import 'package:noor_quran/features/hadith/data/models/hadith.dart';

class SplashScreen extends ConsumerStatefulWidget {
  final bool hasSeenOnboarding;
  const SplashScreen({super.key, required this.hasSeenOnboarding});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  double _progress = 0.0;
  String _loadingText = "جاري تهيئة التطبيق...";

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final isar = sl<Isar>();

      // 1. فحص هل قاعدة البيانات تحتوي على بيانات (لتجنب التكرار)
      final hadithCount = await isar.hadiths.count();

      if (hadithCount == 0) {
        // المرحلة 1: القرآن (30%)
        setState(() {
          _loadingText = "جاري إعداد صفحات القرآن الكريم...";
          _progress = 0.1;
        });
        await insertQuranPagesToIsar();

        // المرحلة 2: الأحاديث (60%)
        setState(() {
          _loadingText = "جاري تحميل الأحاديث النبوية...";
          _progress = 0.4;
        });
        await insertHadithToIsar();

        // المرحلة 3: التفاسير (80%)
        setState(() {
          _loadingText = "جاري إعداد كتب التفسير...";
          _progress = 0.7;
        });
        await loadTafsserFromAssest();
      }

      // المرحلة 4: الموقع وأوقات الصلاة (دائماً تعمل)
      setState(() {
        _loadingText = "جاري تحديد موقعك لمواقيت الصلاة...";
        _progress = 0.85;
      });

      final locationLocator = sl<LocationLocatorImpl>();

      final pos = await locationLocator.determinePosition();

      pos.fold(
        (failure) {
          ref.read(locationStatusProvider.notifier).setStatus({
            LocationMessage.error: failure.message,
          });
        },
        (position) async {
          ref.read(userPositionProvider.notifier).state = position;

          await ref
              .read(prayTimesNotifierProvider.notifier)
              .fetchAndSaveMonthlyTimes(
                latitude: position.latitude,
                longitude: position.longitude,
              );
        },
      );

      setState(() {
        _progress = 1.0;
        _loadingText = "تم التجهيز بنجاح";
      });

      // الانتقال للوجهة الصحيحة
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(
          widget.hasSeenOnboarding ? "/custom_navigation_bar" : "/onboarding",
        );
      }
    } catch (e) {
      AppLogger.logger.e("حصل مشكلة اثناء تهيئة التطبيق: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(width: double.infinity, child: _buildLoadingState()),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // تأثير الأنيميشن للشعار
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1500),
          tween: Tween(begin: 0.8, end: 1.0),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.asset(
                // TODO: set app icon when is ready
                "assets/icons/moon.png",
                width: 120.w,
                height: 120.w,
              ),
            ),
          ),
        ),

        SizedBox(height: 60.h),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w),
          child: Column(
            children: [
              // شريط التحميل
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 10.h,
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // نص التحميل المتحرك
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  _loadingText,
                  key: ValueKey(_loadingText),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Cairo",
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              Text(
                "${(_progress * 100).toInt()}%",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                  fontFamily: "Cairo",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
