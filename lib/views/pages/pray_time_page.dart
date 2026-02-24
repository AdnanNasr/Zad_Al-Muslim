import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:adhan/adhan.dart'; // تأكد من استيراد مكتبة adhan
import 'package:noor_quran/extensions/color_ext.dart';
import 'package:noor_quran/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:noor_quran/view_models/providers/hadith_provider.dart';

import '../../view_models/providers/pray_times_provider.dart';
import '../../view_models/models/prayer_times/prayer_times_model.dart';

class PrayTimePage extends ConsumerWidget {
  // الصفحة الآن تعتمد على Riverpod provider لتحميل مواقيت اليوم
  const PrayTimePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const topContentColor = Colors.white;

    // تعريف أيقونات الصلوات
    final Map<String, IconData> prayerIcons = {
      "الفجر": Icons.wb_twilight,
      "الشروق": Icons.wb_sunny_outlined,
      "الظهر": Icons.wb_sunny,
      "العصر": Icons.wb_cloudy_outlined,
      "المغرب": Icons.nightlight_round,
      "العشاء": Icons.bedtime,
    };

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.color.primary,
              context.color.primary.withValues(alpha: .8),
            ],
          ),
        ),
        child: SafeArea(
          child: ref
              .watch(todayPrayerTimesProvider)
              .when(
                data: (model) {
                  if (model == null) {
                    return _buildErrorState(
                      error: "تعذر الحصول على مواقيت الصلاة",
                      context: context,
                      ref: ref
                    );
                  }

                  // نقوم ببناء قائمة عادية من الموديل
                  final prayerList = [
                    {"name": "الفجر", "time": model.fajr},
                    {"name": "الشروق", "time": model.sunrise},
                    {"name": "الظهر", "time": model.dhuhr},
                    {"name": "العصر", "time": model.asr},
                    {"name": "المغرب", "time": model.maghrib},
                    {"name": "العشاء", "time": model.isha},
                  ];

                  final currentPrayer = _currentPrayerFromModel(model);

                  return Column(
                    children: [
                      _buildAppBar(context, topContentColor),
                      SizedBox(height: 15.h),
                      Text(
                        "مواقيت الصلاة",
                        style: TextStyle(
                          color: topContentColor,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "ألمانيا، برلين", // يمكنك جلب اسم المدينة برمجياً لاحقاً
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 30.h),

                      // عرض الصلاة القادمة والعداد التنازلي
                      _buildNextPrayerCard(context, model, topContentColor),

                      SizedBox(height: 30.h),

                      // قائمة المواقيت
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 30.h,
                            left: 20.w,
                            right: 20.w,
                          ),
                          decoration: BoxDecoration(
                            color: context.color.surface,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.r),
                              topRight: Radius.circular(40.r),
                            ),
                          ),
                          child: ListView.builder(
                            itemCount: prayerList.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = prayerList[index];
                              final name = item['name'] as String;
                              final time = item['time'] as DateTime;
                              // فحص إذا كانت هذه هي الصلاة الحالية
                              bool isCurrent = _checkIfCurrent(
                                name,
                                currentPrayer,
                              );

                              return _buildPrayerRow(
                                context,
                                name,
                                DateFormat.jm().format(time.toLocal()),
                                prayerIcons[name] ?? Icons.circle,
                                isCurrent: isCurrent,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                error: (err, _) =>
                    _buildErrorState(error: err.toString(), context: context, ref: ref),
              ),
        ),
      ),
    );
  }

  // دالة مساعدة لتحديد الصلاة الحالية
  bool _checkIfCurrent(String name, Prayer current) {
    if (name == "الفجر" && current == Prayer.fajr) return true;
    if (name == "الشروق" && current == Prayer.sunrise) return true;
    if (name == "الظهر" && current == Prayer.dhuhr) return true;
    if (name == "العصر" && current == Prayer.asr) return true;
    if (name == "المغرب" && current == Prayer.maghrib) return true;
    if (name == "العشاء" && current == Prayer.isha) return true;
    return false;
  }

  Widget _buildAppBar(BuildContext context, Color color) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        tooltip: AppLocalizations.of(context)!.go_back,
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.arrow_back, color: color, size: 24.sp),
      ),
    );
  }

  Widget _buildErrorState({
    required String error,
    required BuildContext context,
    required WidgetRef ref
  }) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // أيقونة تعبيرية تعطي طابعاً بصرياً فورياً للخطأ
                    Icon(
                      Icons.signal_wifi_off_rounded,
                      size: 80.r,
                      color: Colors.white.withValues(alpha: .8),
                    ),
                    SizedBox(height: 24.h),

                    // عنوان الخطأ
                    Text(
                      "عذراً، حدث خطأ ما",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: "Cairo",
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // تفاصيل الخطأ والإرشادات
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "يرجى تفعيل الـ GPS والاتصال بالإنترنت لمرة واحدة على الأقل لتحميل البيانات.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white70,
                              fontFamily: "Cairo",
                            ),
                          ),
                          Divider(color: Colors.white24, height: 20.h),
                          Text(
                            "التفاصيل التقنية: $error",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.white60,
                              fontFamily: "Cairo",
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // زر إعادة المحاولة يعطي للمستخدم حلاً بدلاً من طريق مسدود
                    ElevatedButton.icon(
                      onPressed: () {
                        // هنا يمكنك استدعاء دالة إعادة التحميل
                        ref.invalidate(hadithProvider);
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      iconAlignment: IconAlignment.end,
                      label: const Text("إعادة المحاولة"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.color.primary,
                        foregroundColor: Colors.white,
                        iconColor: context.color.onPrimary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextPrayerCard(
    BuildContext context,
    PrayerTimesModel prayerModel,
    Color textColor,
  ) {
    final Prayer next = _nextPrayerFromModel(prayerModel);
    final nextTime = _timeForPrayerFromModel(prayerModel, next);

    // حساب المتبقي (ساعات ودقائق)
    final remaining = nextTime.difference(DateTime.now());
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);

    return Container(
      padding: EdgeInsets.all(20.h),
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: Colors.white24, width: 1.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "الصلاة القادمة: ${_translatePrayer(next)}",
            style: TextStyle(color: textColor, fontSize: 16.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}",
            style: TextStyle(
              color: textColor,
              fontSize: 38.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "متبقي على الأذان",
            style: TextStyle(color: Colors.white70, fontSize: 15.sp),
          ),
        ],
      ),
    );
  }

  String _translatePrayer(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return "الفجر";
      case Prayer.sunrise:
        return "الشروق";
      case Prayer.dhuhr:
        return "الظهر";
      case Prayer.asr:
        return "العصر";
      case Prayer.maghrib:
        return "المغرب";
      case Prayer.isha:
        return "العشاء";
      default:
        return "قريباً";
    }
  }

  /// helpers that work with [PrayerTimesModel]
  Prayer _nextPrayerFromModel(PrayerTimesModel model) {
    final now = DateTime.now();
    if (now.isBefore(model.fajr)) return Prayer.fajr;
    if (now.isBefore(model.sunrise)) return Prayer.sunrise;
    if (now.isBefore(model.dhuhr)) return Prayer.dhuhr;
    if (now.isBefore(model.asr)) return Prayer.asr;
    if (now.isBefore(model.maghrib)) return Prayer.maghrib;
    if (now.isBefore(model.isha)) return Prayer.isha;
    return Prayer.fajr; // غدا
  }

  Prayer _currentPrayerFromModel(PrayerTimesModel model) {
    final now = DateTime.now();
    if (now.isBefore(model.fajr)) return Prayer.fajr;
    if (now.isBefore(model.sunrise)) return Prayer.sunrise;
    if (now.isBefore(model.dhuhr)) return Prayer.dhuhr;
    if (now.isBefore(model.asr)) return Prayer.asr;
    if (now.isBefore(model.maghrib)) return Prayer.maghrib;
    if (now.isBefore(model.isha)) return Prayer.isha;
    return Prayer.isha;
  }

  DateTime _timeForPrayerFromModel(PrayerTimesModel model, Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return model.fajr;
      case Prayer.sunrise:
        return model.sunrise;
      case Prayer.dhuhr:
        return model.dhuhr;
      case Prayer.asr:
        return model.asr;
      case Prayer.maghrib:
        return model.maghrib;
      case Prayer.isha:
        return model.isha;
      default:
        return model.fajr;
    }
  }

  Widget _buildPrayerRow(
    BuildContext context,
    String name,
    String time,
    IconData icon, {
    bool isCurrent = false,
  }) {
    final activeColor = isCurrent
        ? context.color.primary
        : context.color.onSurface.withValues(alpha: 0.6);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: isCurrent
            ? context.color.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(15.r),
        border: isCurrent
            ? Border.all(
                color: context.color.primary.withValues(alpha: 0.3),
                width: 1.w,
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: activeColor, size: 22.sp),
              SizedBox(width: 15.w),
              Text(
                name,
                style: TextStyle(
                  fontSize: 17.sp,
                  color: isCurrent
                      ? context.color.primary
                      : context.color.onSurface,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCurrent
                  ? context.color.primary
                  : context.color.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
