import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:noor_quran/extensions/color_ext.dart';
import 'package:noor_quran/l10n/app_localizations.dart';

class PrayTimePage extends StatelessWidget {
  final Position? position;
  const PrayTimePage({super.key, this.position});

  @override
  Widget build(BuildContext context) {
    // لون ثابت للجزء العلوي المتدرج
    const topContentColor = Colors.white;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage("assets/images/pray_times_cover.jpg"),
          //   fit: BoxFit.fitHeight,
          //   alignment: Alignment.topRight
          // ),
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
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  tooltip: AppLocalizations.of(context)!.go_back,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: topContentColor,
                    size: 24.sp,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              // العنوان والمدينة
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
                "الجمهورية العربية السورية، دمشق",
                style: TextStyle(color: Colors.white70, fontSize: 16.sp),
              ),
              SizedBox(height: 30.h),

              // عرض الصلاة القادمة
              _buildNextPrayerCard(context, topContentColor),

              SizedBox(height: 30.h),

              // قائمة المواقيت
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: context.color.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.r),
                      topRight: Radius.circular(40.r),
                    ),
                  ),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(height: 25.h),
                      _buildPrayerRow(
                        context,
                        "الفجر",
                        "04:45 AM",
                        Icons.wb_twilight,
                      ),
                      _buildPrayerRow(
                        context,
                        "الشروق",
                        "06:10 AM",
                        Icons.wb_sunny_outlined,
                      ),
                      _buildPrayerRow(
                        context,
                        "الظهر",
                        "12:15 PM",
                        Icons.wb_sunny,
                        isCurrent: true,
                      ),
                      _buildPrayerRow(
                        context,
                        "العصر",
                        "03:30 PM",
                        Icons.wb_cloudy_outlined,
                      ),
                      _buildPrayerRow(
                        context,
                        "المغرب",
                        "06:45 PM",
                        Icons.nightlight_round,
                      ),
                      _buildPrayerRow(
                        context,
                        "العشاء",
                        "08:15 PM",
                        Icons.bedtime,
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // بطاقة الصلاة
  Widget _buildNextPrayerCard(BuildContext context, Color textColor) {
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
            "الصلاة القادمة: الظهر",
            style: TextStyle(color: textColor, fontSize: 16.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            "02:15:10",
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

  // سطر مواقيت الصلاة
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
    final rowBgColor = isCurrent
        ? context.color.primary.withValues(alpha: 0.08)
        : Colors.transparent;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: rowBgColor,
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
                  fontFamily: "Cairo",
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
              fontFamily: "Cairo",
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
