import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/utils/network_info.dart';
import 'package:noor_quran/view_models/notifiers/pray_times_notifier.dart';
import 'package:noor_quran/view_models/providers/pray_times_provider.dart';
import 'package:noor_quran/view_models/repositories/insert_hadith.dart';
import 'package:noor_quran/view_models/repositories/insert_quran_pages.dart';
import 'package:noor_quran/view_models/repositories/insert_tafsser.dart';
import 'package:noor_quran/core/utils/location_locator.dart';
import 'package:noor_quran/view_models/models/db/isar_db.dart';
import 'package:noor_quran/view_models/models/db/islamic/hadith.dart';
import 'package:noor_quran/view_models/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  final bool hasSeenOnboarding;
  const SplashScreen({super.key, required this.hasSeenOnboarding});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  double _progress = 0.0;
  String _loadingText = "جاري تهيئة التطبيق...";
  Object? _error;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final isar = IsarDb.database;

      // 1. فحص هل قاعدة البيانات تحتوي على بيانات (لتجنب التكرار)
      final hadithCount = await isar!.hadiths.count();

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

      // الحصول على موقع المستخدم
      final internetConnection = await NetworkInfo.hasValidConnection();
      // اذا كان هناك اتصال بالانترنت
      if (internetConnection) {
        final position = await LocationLocator.determinePosition(ref);

        // if (position != null) {
        //   AppLogger.logger.i(
        //     "تم جلب موقع المستخدم بنجاح\nخطوط العرض: ${position.latitude}\nخطوط الطول: ${position.longitude}",
        //   );
        // } else {
        //   AppLogger.logger.e(
        //     "خطأ في جلب موقع المستخدم\nخطوط العرض: ${position?.latitude}\nخطوط الطول: ${position?.longitude}",
        //   );
        // }

        if (position != null) {
          // حفظ الموقع في الموفر حتى يتمكن باقي التطبيق من الوصول له لاحقاً
          // (مثلاً داخل PrayTimesContainer عند القراءة من اليوم).
          ref.read(userPositionProvider.notifier).state = position;

          await ref
              .read(prayTimesNotifierProvider.notifier)
              .fetchAndSaveMonthlyTimes(
                latitude: position.latitude,
                longitude: position.longitude,
              );
        }
      }

      // اذا كان هناك اتصال بالانترنت
      if (!internetConnection) {
        final prefs = await SharedPreferences.getInstance();

        final lat = prefs.getDouble("lat");
        final long = prefs.getDouble("long");

        if (lat != null && long != null) {
          await ref
              .read(prayTimesNotifierProvider.notifier)
              .fetchAndSaveMonthlyTimes(latitude: lat, longitude: long);
        }
        AppLogger.logger.e(
          "ليس هناك اتصال حالي بالانترنت\nلم يتم طلب الحصول على بيانات الموقع الخاصة بالمستخدم",
        );
      }

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
      setState(() {
        _error = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: _error != null ? _buildErrorState() : _buildLoadingState(),
      ),
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

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80.r,
              color: Colors.redAccent,
            ),
            SizedBox(height: 20.h),
            Text(
              "حدث خطأ أثناء التهيئة",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: "Cairo",
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "تأكد من الإنترنت والـ GPS: $_error",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
                fontFamily: "Cairo",
              ),
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _error = null;
                  _progress = 0;
                });
                _initializeApp();
              },
              child: const Text("إعادة المحاولة"),
            ),
          ],
        ),
      ),
    );
  }
}
