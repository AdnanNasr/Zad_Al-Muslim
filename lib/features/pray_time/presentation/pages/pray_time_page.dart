import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:adhan/adhan.dart';
import 'package:noor_quran/core/common/providers/user_position_provider.dart';
import 'package:noor_quran/core/constants/enums/my_enums.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:intl/intl.dart';
import 'package:noor_quran/core/utils/location/location_locator.dart';
import 'package:noor_quran/core/common/providers/location_status_provider.dart';
import 'package:noor_quran/core/common/providers/network_info_provider.dart';
import 'package:noor_quran/features/pray_time/presentation/providers/user_address_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/pray_times_provider.dart';
import '../../data/models/prayer_times_model.dart';

class PrayTimePage extends ConsumerStatefulWidget {
  const PrayTimePage({super.key});

  @override
  ConsumerState<PrayTimePage> createState() => _PrayTimePageState();
}

class _PrayTimePageState extends ConsumerState<PrayTimePage>
    with WidgetsBindingObserver {
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Start countdown timer to update every minute
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // استدعاء مباشر وآمن خارج دورة البناء
      Future.microtask(() => _recheckLocationOnResume());
    }
  }

  Future<void> _recheckLocationOnResume() async {
    final networkState = ref.read(networkInfoProvider);
    if (networkState == NetworkInfoState.connected) {
      // Only re-check if we have internet
      final pos = await LocationLocator.determinePosition(ref);
      if (pos != null) {
        ref.read(userPositionProvider.notifier).state = pos;
        ref.invalidate(todayPrayerTimesProvider);
        ref.read(locationStatusProvider.notifier).clearStatus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

    // location status message
    final locationStatusMessage = ref.watch(locationStatusProvider);
    final networkState = ref.watch(networkInfoProvider);
    final prayerTimesAsync = ref.watch(todayPrayerTimesProvider);

    // monitor network state: when it becomes connected, check if we need to
    // fetch the location automatically (if permissions are already granted and
    // we don't have a position yet).
    ref.listen<NetworkInfoState>(networkInfoProvider, (previous, next) {
      if (next == NetworkInfoState.connected) {
        Future.microtask(() => _checkAndFetchLocation());
      }
    });

    // also monitor location status: when permissions are granted and we don't
    // have a position yet, try to fetch it.
    ref.listen(locationStatusProvider, (previous, next) {
      if (next.keys.isNotEmpty &&
          next.keys.first == LocationMessage.locationAllowed) {
        Future.microtask(() => _checkAndFetchLocation());
      }
    });

    final userAddress = ref.watch(userAddressProvider);

    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back, color: context.color.onPrimary),
                ),
              ),
              Expanded(
                child: prayerTimesAsync.when(
                  data: (model) {
                    // تحديث الحالة بعد انتهاء الـ build
                    if (model != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          ref
                              .read(locationStatusProvider.notifier)
                              .clearStatus();
                        }
                      });
                    }

                    if (model == null) {
                      return _buildErrorState(
                        error: "تعذر الحصول على مواقيت الصلاة",
                        context: context,
                        status: locationStatusMessage,
                        networkState: networkState,
                        prayerTimes: model,
                      );
                    }

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
                        SizedBox(height: 15.h),
                        Text(
                          "أوقات الصلاة",
                          style: TextStyle(
                            color: topContentColor,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Cairo",
                          ),
                        ),
                        SizedBox(height: 5.h),
                        userAddress.when(
                          data: (data) => Text(
                            "${data?.country} | ${data?.locality}",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20.sp,
                            ),
                          ),
                          error: (error, stackTrace) =>
                              Text("حدث خطأ اثناء جلب العنوان"),
                          loading: () => LinearProgressIndicator(),
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
                  loading: () {
                    // إذا تم منح الإذن لكن البيانات لم يتم تحميلها بعد
                    if (locationStatusMessage.isNotEmpty &&
                        locationStatusMessage.keys.first ==
                            LocationMessage.locationAllowed) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "جاري التحميل...",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: context.color.primary,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            CircularProgressIndicator(
                              color: context.color.onPrimary,
                            ),
                          ],
                        ),
                      );
                    }

                    // الحالة الافتراضية أثناء التحميل
                    return Center(
                      child: CircularProgressIndicator(
                        color: context.color.onPrimary,
                      ),
                    );
                  },

                  error: (err, _) => _buildErrorState(
                    error: err.toString(),
                    context: context,
                    status: locationStatusMessage,
                    networkState: networkState,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Checks if network is connected, permissions are granted, and we don't
  /// have a position yet. If so, fetches the position automatically.
  ///
  /// This method is called via ref.listen to ensure it runs as a side effect
  /// of state changes, not during the build phase.
  Future<void> _checkAndFetchLocation() async {
    final networkState = ref.read(networkInfoProvider);
    final locationStatus = ref.read(locationStatusProvider);
    final userPos = ref.read(userPositionProvider);

    // Only proceed if all conditions are met
    if (networkState == NetworkInfoState.connected &&
        locationStatus.keys.isNotEmpty &&
        locationStatus.keys.first == LocationMessage.locationAllowed &&
        userPos == null) {
      final pos = await LocationLocator.determinePosition(ref);
      if (pos != null) {
        ref.read(userPositionProvider.notifier).state = pos;
        ref.invalidate(todayPrayerTimesProvider);
        ref.read(locationStatusProvider.notifier).clearStatus();
      }
    }
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

  Widget _buildErrorState({
    required String error,
    required BuildContext context,
    required Map<LocationMessage, String> status,
    required NetworkInfoState networkState,
    PrayerTimesModel? prayerTimes,
  }) {
    // 1. حالة تحميل التحقق من الشبكة
    if (networkState == NetworkInfoState.loading) {
      return Center(
        child: CircularProgressIndicator(color: context.color.onPrimary),
      );
    }

    // 2. حالة عدم وجود اتصال بالإنترنت
    if (networkState == NetworkInfoState.notConnected && prayerTimes != null) {
      return _buildNoInternetWidget();
    }

    // اذا كانت صلاحيات الموقع غير مقروءة بعد
    if (status.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: context.color.onPrimary),
            SizedBox(height: 16.h),
            Text(
              "جاري التحقق من صلاحيات الموقع...",
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ],
        ),
      );
    }

    // إذا وصلت للمرحلة التي تم فيها منح الصلاحيات بالفعل فإن الخطأ
    // المحتمل هنا هو فقط أن الموفر لم يحصل على الموقع بعد (مثلما يحدث عندما
    // يعود الإنترنت بعد تعطيله). في هذه الحالة لا ينبغي إظهار شاشة خطأ
    // تقنيّة، بل مجرد مؤشر تحميل بسيط بينما نحاول استرجاع الموقع والمواقيت.
    if (status.keys.first == LocationMessage.locationAllowed) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "تم منح صلاحيات الموقع، جارى تحميل مواقيت الصلاة...",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20.h),
            CircularProgressIndicator(color: context.color.onPrimary),
          ],
        ),
      );
    }

    // 3. الحالة الطبيعية (متصل بالإنترنت ولكن يوجد خطأ في الموقع أو غيره)
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getErrorIcon(status.keys.first),
                      size: 80.r,
                      color: Colors.white.withValues(alpha: .8),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "عذراً، حدث خطأ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: "Cairo",
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          Text(
                            status.values.isNotEmpty
                                ? status.values.first
                                : "خطأ غير معروف",
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

                    // أزرار إعادة المحاولة بناءً على نوع الخطأ
                    _buildActionButtons(context, status),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ويدجت مخصص لحالة انقطاع الإنترنت
  Widget _buildNoInternetWidget() {
    return Center(
      child: Container(
        width: 300.w,
        height: 250.h,
        decoration: BoxDecoration(
          border: Border.all(color: context.color.primary),
          borderRadius: BorderRadius.circular(20.r),
          color: context.color.onPrimary,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              blurStyle: BlurStyle.outer,
              color: Colors.black38,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 90.r,
              color: context.color.error,
            ),
            SizedBox(height: 16.h),
            Text(
              "لا يوجد اتصال بالإنترنت",
              style: TextStyle(
                color: context.color.primary,
                fontSize: 20.sp,
                fontFamily: "Cairo",
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 18.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.color.primary,
                foregroundColor: context.color.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 60.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.r),
                ),
              ),
              onPressed: () async {
                final internetConnection = await ref
                    .read(networkInfoProvider.notifier)
                    .checkNetworkState();

                final prefs = await SharedPreferences.getInstance();

                final lat = prefs.getDouble("lat");
                final long = prefs.getDouble("long");

                if (!mounted) return;

                if (!internetConnection || lat != null && long != null) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ErrorDialog(
                        title: "مشكلة في الاتصال",
                        description:
                            "لم يتم الاتصال بالإنترنت، يرجى التحقق من الشبكة للمتابعة.",
                        icon: Icons.wifi_off_rounded,
                      );
                    },
                  );
                } else {
                  // network came back; try to determine position which will handle
                  // GPS disabled case by opening settings and setting appropriate status
                  final pos = await LocationLocator.determinePosition(ref);
                  if (pos != null) {
                    ref.read(userPositionProvider.notifier).state = pos;
                    ref.invalidate(todayPrayerTimesProvider);
                    ref.read(locationStatusProvider.notifier).clearStatus();
                  }
                  // If pos is null, LocationLocator will have set the appropriate status
                  // (GPS disabled or permissions denied), so the page will show the error state
                }
              },
              child: Padding(
                padding: EdgeInsets.all(8.0.r),
                child: Text(
                  "تحديث",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: context.color.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لتحديد الأيقونة بناءً على نوع رسالة الموقع
  IconData _getErrorIcon(LocationMessage message) {
    switch (message) {
      case LocationMessage.locationDisabled:
      case LocationMessage.locationNotAllowed:
      case LocationMessage.locationNotAllowedEver:
        return Icons.location_off_rounded;
      default:
        return Icons.error_outline_rounded;
    }
  }

  // فصل أزرار الأكشن لتبسيط الكود الأساسي
  Widget _buildActionButtons(
    BuildContext context,
    Map<LocationMessage, String> status,
  ) {
    final messageType = status.keys.first;

    return ElevatedButton.icon(
      onPressed: () async {
        // when permissions are allowed we may still not have a position
        // (e.g. previous requests failed because of no internet). treat it
        // similar to the notAllowed cases by trying to obtain the location
        if (messageType == LocationMessage.locationDisabled ||
            messageType == LocationMessage.locationNotAllowed ||
            messageType == LocationMessage.locationNotAllowedEver ||
            messageType == LocationMessage.locationAllowed) {
          final pos = await LocationLocator.determinePosition(ref);
          if (pos != null) {
            ref.read(userPositionProvider.notifier).state = pos;
            ref.invalidate(todayPrayerTimesProvider);
            // once we have a valid position clear the status so that future
            // builds don't think we're still in an "error" state
            ref.read(locationStatusProvider.notifier).clearStatus();
          } else if (messageType == LocationMessage.locationNotAllowedEver) {
            if (!context.mounted) return;
            // إظهار الديالوج في حالة الرفض النهائي
            // _showPermissionDialog(context);
          }
        } else {
          // No action needed, just rebuild naturally
        }
      },
      icon: messageType == LocationMessage.locationNotAllowedEver
          ? const Icon(Icons.settings)
          : const Icon(Icons.refresh_rounded),
      label: Text(
        messageType == LocationMessage.locationNotAllowedEver
            ? "فتح الإعدادات"
            : "إعادة المحاولة",
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
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
    final seconds = remaining.inSeconds.remainder(60);

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
            style: TextStyle(color: textColor, fontSize: 18.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, "0")}",
            style: TextStyle(
              color: textColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "متبقي على الأذان",
            style: TextStyle(color: Colors.white70, fontSize: 18.sp),
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

class ErrorDialog extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  const ErrorDialog({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r), // حواف منحنية ناعمة
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ليأخذ الدايلوج حجم المحتوى فقط
          children: [
            // 1. أيقونة تنبيه ملونة
            Icon(
              icon,
              size: 60.r,
              color: context.color.error.withValues(alpha: 0.8),
            ),
            SizedBox(height: 16.h),

            // 2. العنوان
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: "Cairo", // تأكد من استخدام خطك المعتمد
                color: context.color.onSurface,
              ),
            ),
            SizedBox(height: 12.h),

            // 3. نص الرسالة
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: context.color.onSurfaceVariant,
                fontFamily: "Cairo",
              ),
            ),
            SizedBox(height: 24.h),

            // 4. زر الإغلاق أو إعادة المحاولة
            SizedBox(
              width: double.infinity, // الزر يأخذ عرض الدايلوج
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.color.primary,
                  foregroundColor: context.color.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  "حسناً",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
