import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/extensions/sizes_ext.dart';
import 'package:noor_quran/l10n/app_localizations.dart';

class PrayTimesContainer extends ConsumerWidget {
  const PrayTimesContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: context.witdthScreen <= 360 ? 280.h : 250.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        // borderRadius: BorderRadiusGeometry.vertical(
        //   bottom: Radius.elliptical(200.w, 30.h),
        // ),
        image: const DecorationImage(
          image: AssetImage("assets/images/pray_times_cover.jpg"),
          fit: BoxFit.cover,
          opacity: .8,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.colorBurn),
        ),
      ),
      padding: EdgeInsets.all(context.witdthScreen * 0.01),
      child: Padding(
        padding: EdgeInsets.only(top: 50.h),
        child: Column(
          children: [
            Text(
              "نور البيان",
              style: TextStyle(
                fontSize: 35.sp,
                fontWeight: FontWeight.bold,
                fontFamily: "Tajawal",
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.h),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.pray_times,
                  style: TextStyle(
                    fontSize: context.witdthScreen * 0.06,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.heightScreen * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _PrayTimeItem(
                      title: AppLocalizations.of(context)!.fajer,
                      time: "04:21",
                    ),
                    _PrayTimeItem(
                      title: AppLocalizations.of(context)!.duhur,
                      time: "12:35",
                    ),
                    _PrayTimeItem(
                      title: AppLocalizations.of(context)!.asr,
                      time: "15:58",
                    ),
                    _PrayTimeItem(
                      title: AppLocalizations.of(context)!.magrib,
                      time: "18:42",
                    ),
                    _PrayTimeItem(
                      title: AppLocalizations.of(context)!.esha,
                      time: "20:10",
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PrayTimeItem extends ConsumerWidget {
  final String title;
  final String time;

  const _PrayTimeItem({required this.title, required this.time});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyleTitle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: context.heightScreen * 0.028,
    );

    final textStyleTime = TextStyle(
      color: Colors.white,
      fontSize: context.heightScreen * 0.016,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: textStyleTitle),
        SizedBox(height: context.heightScreen * 0.005),
        Text(time, style: textStyleTime),
      ],
    );
  }
}
