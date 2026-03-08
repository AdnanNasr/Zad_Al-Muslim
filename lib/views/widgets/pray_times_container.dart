import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view_models/providers/pray_times_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';

class PrayTimesContainer extends ConsumerWidget {
  const PrayTimesContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncModel = ref.watch(todayPrayerTimesProvider);

    String format(DateTime dt) => DateFormat.Hm().format(dt.toLocal());

    return asyncModel.when(
      data: (model) {
        // إذا لم تتوفر البيانات، نظهر المحتوى الافتراضي
        final fajr = model?.fajr;
        final dhuhr = model?.dhuhr;
        final asr = model?.asr;
        final maghrib = model?.maghrib;
        final esha = model?.isha;

        return Container(
          height: context.witdthScreen <= 360 ? 280.h : 250.h,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
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
                          time: fajr != null ? format(fajr) : "--:--",
                        ),
                        _PrayTimeItem(
                          title: AppLocalizations.of(context)!.duhur,
                          time: dhuhr != null ? format(dhuhr) : "--:--",
                        ),
                        _PrayTimeItem(
                          title: AppLocalizations.of(context)!.asr,
                          time: asr != null ? format(asr) : "--:--",
                        ),
                        _PrayTimeItem(
                          title: AppLocalizations.of(context)!.magrib,
                          time: maghrib != null ? format(maghrib) : "--:--",
                        ),
                        _PrayTimeItem(
                          title: AppLocalizations.of(context)!.esha,
                          time: esha != null ? format(esha) : "--:--",
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Container(
        height: context.witdthScreen <= 360 ? 280.h : 250.h,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Colors.white),
      ),
      error: (err, _) => Container(
        height: context.witdthScreen <= 360 ? 280.h : 250.h,
        alignment: Alignment.center,
        child: Text(
          AppLocalizations.of(context)!.pray_times,
          style: const TextStyle(color: Colors.white),
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
