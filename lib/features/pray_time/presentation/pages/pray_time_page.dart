import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:adhan/adhan.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:noor_quran/core/common/providers/user_position_provider.dart';
import 'package:noor_quran/core/constants/enums/my_enums.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:intl/intl.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/utils/location/location_locator.dart';
import 'package:noor_quran/core/utils/location/providers/location_status_provider.dart';
import 'package:noor_quran/core/common/providers/network_info_provider.dart';
import 'package:noor_quran/core/utils/location/providers/service_status_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:noor_quran/features/pray_time/presentation/providers/user_address_provider.dart';
import 'package:noor_quran/features/settings/presentation/providers/app_settings_provider.dart';
import 'package:noor_quran/features/pray_time/data/models/prayer_adjustments_model.dart';

import '../providers/pray_times_provider.dart';
import '../providers/prayer_adjustments_provider.dart';
import '../../domain/entities/prayer_times_entity.dart';

class PrayTimePage extends ConsumerStatefulWidget {
  const PrayTimePage({super.key});

  @override
  ConsumerState<PrayTimePage> createState() => _PrayTimePageState();
}

class _PrayTimePageState extends ConsumerState<PrayTimePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  Timer? _countdownTimer;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startCountdownTimer();
    Future.microtask(() => _checkAndFetchLocation());

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0.0, 0.05), // Subtle slide from bottom
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      Future.microtask(() => _recheckLocationOnResume());
    }
  }

  Future<void> _recheckLocationOnResume() async {
    final networkState = ref.read(networkInfoProvider);
    if (networkState == NetworkInfoState.connected) {
      final status = ref.read(locationStatusProvider);
      if (status.isEmpty) {
        await ref.read(locationStatusProvider.notifier).refreshStatus();
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ref.read(locationStatusProvider.notifier).setStatus({
          LocationMessage.locationDisabled: "الـ GPS معطل، يرجى تفعيله",
        });
        return;
      }

      final locationLocator = sl<LocationLocatorImpl>();
      final pos = await locationLocator.determinePosition();

      pos.fold(
        (failure) {
          ref.read(locationStatusProvider.notifier).setStatus({
            LocationMessage.error: failure.message,
          });
        },
        (position) {
          ref.read(userPositionProvider.notifier).state = position;
          ref.read(locationStatusProvider.notifier).clearStatus();
        },
      );

      ref.invalidate(selectedDatePrayerTimesProvider);
      ref.invalidate(todayPrayerTimesProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final use24format = ref.watch(appSettingsProvider).use24HourFormat;
    final locationStatusMessage = ref.watch(locationStatusProvider);
    final networkState = ref.watch(networkInfoProvider);
    final prayerTimesAsync = ref.watch(selectedDatePrayerTimesProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final adjustmentsAsync = ref.watch(prayerAdjustmentsProvider);
    final adjustments =
        adjustmentsAsync.valueOrNull ?? PrayerAdjustmentsModel();

    ref.listen<NetworkInfoState>(networkInfoProvider, (previous, next) {
      if (next == NetworkInfoState.connected) {
        Future.microtask(() => _checkAndFetchLocation());
      }
    });

    ref.listen<AsyncValue<ServiceStatus>>(serviceStatusProvider, (
      previous,
      next,
    ) {
      if (next.value == ServiceStatus.enabled) {
        Future.microtask(() => _checkAndFetchLocation());
      }
    });

    ref.listen(locationStatusProvider, (previous, next) {
      if (next.keys.isNotEmpty &&
          next.keys.first == LocationMessage.locationAllowed) {
        Future.microtask(() => _checkAndFetchLocation());
      }
    });

    final userAddress = ref.watch(userAddressProvider);
    final isCurrentDay = isToday(selectedDate);

    final themeMode = ref.watch(themeProvider);

    return Container(
      decoration: BoxDecoration(
        // TODO: make desstion
        // image: DecorationImage(
        //   image: AssetImage("assets/images/pray_times_cover.jpg"),
        //   fit: BoxFit.cover,
        // ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.color.primary,
            context.color.primary.withValues(alpha: 0.85),
            HSLColor.fromColor(context.color.primary)
                .withLightness(
                  (HSLColor.fromColor(context.color.primary).lightness -
                          (themeMode == ThemeMode.light ? 0.02 : 0.35))
                      .clamp(0.0, 1.0),
                )
                .toColor(),
          ],
          stops: const [0.0, 0.0, 0.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: RefreshIndicator(
            color: context.color.primary,
            backgroundColor: Colors.white,
            onRefresh: () async {
              ref.invalidate(selectedDatePrayerTimesProvider);
              await ref.read(userAddressProvider.notifier).refresh();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: context.mediaQueryHeight,
                width: context.mediaQueryWidth,
                child: Column(
                  children: [
                    // --- شريط علوي ---
                    Container(
                      decoration: const BoxDecoration(),
                      child: _buildTopBar(
                        context,
                        userAddress,
                        isCurrentDay,
                        selectedDate,
                      ),
                    ),

                    // --- محتوى الصفحة ---
                    Expanded(
                      child: prayerTimesAsync.when(
                        data: (entity) {
                          if (entity != null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                ref
                                    .read(locationStatusProvider.notifier)
                                    .clearStatus();
                              }
                            });
                          }

                          if (entity == null) {
                            return _buildErrorState(
                              error: "تعذر الحصول على مواقيت الصلاة",
                              context: context,
                              status: locationStatusMessage,
                              networkState: networkState,
                            );
                          }

                          return SlideTransition(
                            position: _slideAnimation,
                            child: _buildPrayerContent(
                              context,
                              entity,
                              adjustments,
                              use24format,
                              isCurrentDay,
                            ),
                          );
                        },
                        loading: () =>
                            _buildLoadingState(context, locationStatusMessage),
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
          ),
        ),
      ),
    );
  }

  // ==========================================
  // شريط العنوان العلوي
  // ==========================================
  Widget _buildTopBar(
    BuildContext context,
    AsyncValue userAddress,
    bool isCurrentDay,
    DateTime selectedDate,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // زر الرجوع
          Tooltip(
            message: "الصفحة الرئيسية",
            child: Material(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () {
                  selectedDate = DateTime.now();
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // العنوان والموقع
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "أوقات الصلاة",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Cairo",
                  ),
                ),
                userAddress.when(
                  data: (data) {
                    if (data != null) {
                      return Text(
                        "${data.country} • ${data.locality}",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12.sp,
                          fontFamily: "Cairo",
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  error: (_, __) => const SizedBox.shrink(),
                  loading: () => Skeletonizer(
                    enabled: true,
                    effect: ShimmerEffect(
                      baseColor: context.color.primary.withValues(alpha: 0.2),
                      highlightColor: context.color.primary.withValues(
                        alpha: 0.1,
                      ),
                    ),
                    child: Text(
                      "جاري تحميل الموقع...",
                      style: TextStyle(
                        color: context.color.primary.withValues(alpha: 0.8),
                        fontSize: 12.sp,
                        fontFamily: "Cairo",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // مؤشر اليوم الحالي
          if (!isCurrentDay)
            GestureDetector(
              onTap: () {
                final now = DateTime.now();
                ref.read(selectedDateProvider.notifier).state = DateTime(
                  now.year,
                  now.month,
                  now.day,
                );
                _animationController.reset();
                _animationController.forward();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.white38),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.today_rounded,
                      color: Colors.white70,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "اليوم",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: "Cairo",
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================
  // بناء المحتوى الرئيسي للأوقات
  // ==========================================
  Widget _buildPrayerContent(
    BuildContext context,
    PrayerTimesEntity entity,
    PrayerAdjustmentsModel adjustments,
    bool use24format,
    bool isCurrentDay,
  ) {
    final prayerIcons = {
      "الفجر": Icons.wb_twilight_rounded,
      "الشروق": Icons.wb_sunny_outlined,
      "الظهر": Icons.wb_sunny_rounded,
      "العصر": Icons.cloud_outlined,
      "المغرب": Icons.nightlight_round,
      "العشاء": Icons.bedtime_rounded,
    };

    final prayerList = [
      {"name": "الفجر", "time": entity.fajr},
      {"name": "الشروق", "time": entity.sunrise},
      {"name": "الظهر", "time": entity.dhuhr},
      {"name": "العصر", "time": entity.asr},
      {"name": "المغرب", "time": entity.maghrib},
      {"name": "العشاء", "time": entity.isha},
    ];

    final currentPrayer = isCurrentDay
        ? _currentPrayerFromEntity(entity)
        : null;

    return Column(
      children: [
        // --- شريط التنقل بين الأيام ---
        _buildDateNavigationBar(context),

        SizedBox(height: 16.h),

        // --- بطاقة الصلاة القادمة (فقط لليوم الحالي) ---
        if (isCurrentDay) _buildNextPrayerCard(context, entity),

        if (isCurrentDay) SizedBox(height: 16.h),

        // --- قائمة المواقيت (القسم الأسفل) ---
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: context.color.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                // مقبض السحب
                Container(
                  margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: context.color.onSurface.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),

                // عنوان القسم مع زر إعادة التعيين
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "مواقيت الصلاة",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: context.color.onSurface,
                          fontFamily: "Cairo",
                        ),
                      ),
                      if (adjustments.hasAnyAdjustment)
                        GestureDetector(
                          onTap: () => _showResetConfirmation(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: Colors.orange.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.orange,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "إعادة تعيين",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12.sp,
                                    fontFamily: "Cairo",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // قائمة الصلوات
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: prayerList.length,
                    itemBuilder: (context, index) {
                      final item = prayerList[index];
                      final name = item['name'] as String;
                      final time = item['time'] as DateTime;
                      final isCurrent =
                          currentPrayer != null &&
                          _checkIfCurrent(name, currentPrayer);
                      final offset = adjustments.getOffset(name);
                      final isModified = offset != 0;

                      final timeStr = use24format
                          ? DateFormat.Hm().format(time.toLocal())
                          : DateFormat.jm("ar").format(time.toLocal());

                      return _buildPrayerRow(
                        context: context,
                        name: name,
                        time: timeStr,
                        icon: prayerIcons[name] ?? Icons.circle,
                        isCurrent: isCurrent,
                        isModified: isModified,
                        offset: offset,
                        adjustments: adjustments,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // هيكل التحميل الشبحي (Skeleton Loading)
  // ==========================================
  Widget _buildSkeletonPrayerContent(BuildContext context) {
    final primaryColor = context.color.primary;

    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: primaryColor.withValues(alpha: 0.2),
        highlightColor: primaryColor.withValues(alpha: 0.1),
      ),
      child: Column(
        children: [
          // شريط التاريخ الوهمي
          _buildDateNavigationBar(context),

          SizedBox(height: 16.h),

          // بطاقة الصلاة القادمة الوهمية
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
            height: 110.h,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 10.h,
                        width: 60.w,
                        color: primaryColor.withValues(alpha: 0.2),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 20.h,
                        width: 100.w,
                        color: primaryColor.withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // قائمة الصلوات الوهمية
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.color.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              ),
              child: Column(
                children: [
                  // مقبض
                  Container(
                    margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 6.h),
                          height: 70.h,
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // شريط التنقل بين الأيام
  // ==========================================
  Widget _buildDateNavigationBar(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final canForward = canGoForward(selectedDate);
    final canBack = canGoBack(selectedDate);
    final isCurrentDay = isToday(selectedDate);

    String dateLabel;
    if (isCurrentDay) {
      dateLabel = "اليوم";
    } else {
      final diff = selectedDate
          .difference(
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
          )
          .inDays;

      if (diff == 1) {
        dateLabel = "الغد";
      } else if (diff == -1) {
        dateLabel = "أمس";
      } else {
        dateLabel = DateFormat('EEE، d MMM', 'ar').format(selectedDate);
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر السابق
          _buildNavButton(
            message: "السابق",
            icon: Icons.chevron_left_rounded,
            enabled: canBack,
            onTap: () {
              if (canBack) {
                ref.read(selectedDateProvider.notifier).state = selectedDate
                    .subtract(const Duration(days: 1));
                _animationController.reset();
                _animationController.forward();
              }
            },
          ),
          // التاريخ
          Expanded(
            child: GestureDetector(
              onTap: () => _showDatePicker(context, selectedDate),
              child: Column(
                children: [
                  Text(
                    dateLabel,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Cairo",
                    ),
                  ),
                  Text(
                    DateFormat('d MMMM yyyy', 'ar').format(selectedDate),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11.sp,
                      fontFamily: "Cairo",
                    ),
                  ),
                ],
              ),
            ),
          ),
          // زر القادم
          _buildNavButton(
            message: "القادم",
            icon: Icons.chevron_right_rounded,
            enabled: canForward,
            onTap: () {
              if (canForward) {
                ref.read(selectedDateProvider.notifier).state = selectedDate
                    .add(const Duration(days: 1));
                _animationController.reset();
                _animationController.forward();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
    required String message,
  }) {
    return Tooltip(
      message: message,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: enabled
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            icon,
            color: enabled ? Colors.white : Colors.white30,
            size: 22.sp,
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context, DateTime selected) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: today.subtract(const Duration(days: 30)),
      lastDate: today.add(const Duration(days: 30)),
      locale: const Locale('ar'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: context.color.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      ref.read(selectedDateProvider.notifier).state = DateTime(
        picked.year,
        picked.month,
        picked.day,
      );
      _animationController.reset();
      _animationController.forward();
    }
  }

  // ==========================================
  // بطاقة الصلاة القادمة مع العداد التنازلي
  // ==========================================
  Widget _buildNextPrayerCard(BuildContext context, PrayerTimesEntity entity) {
    final Prayer next = _nextPrayerFromEntity(entity);
    DateTime nextTime = _timeForPrayerFromEntity(entity, next);
    final now = DateTime.now();

    if (nextTime.isBefore(now)) {
      nextTime = nextTime.add(const Duration(days: 1));
    }

    final remaining = nextTime.difference(now);
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);

    final prayerName = _translatePrayer(next);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.22),
            Colors.white.withValues(alpha: 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white30, width: 1.5),
      ),
      child: Row(
        children: [
          // أيقونة الصلاة القادمة
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.access_time_rounded,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          // التفاصيل
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "الصلاة القادمة",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                    fontFamily: "Cairo",
                  ),
                ),
                Text(
                  prayerName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Cairo",
                  ),
                ),
              ],
            ),
          ),
          // العداد التنازلي
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${hours.toString().padLeft(2, '0')}:"
                "${minutes.toString().padLeft(2, '0')}:"
                "${seconds.toString().padLeft(2, '0')}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Text(
                "متبقي على الأذان",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 11.sp,
                  fontFamily: "Cairo",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // صف صلاة واحدة في القائمة
  // ==========================================
  Widget _buildPrayerRow({
    required BuildContext context,
    required String name,
    required String time,
    required IconData icon,
    required bool isCurrent,
    required bool isModified,
    required int offset,
    required PrayerAdjustmentsModel adjustments,
  }) {
    final primaryColor = context.color.primary;
    final surfaceColor = context.color.onSurface;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: isCurrent
            ? primaryColor.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: isCurrent
            ? Border.all(
                color: primaryColor.withValues(alpha: 0.25),
                width: 1.2,
              )
            : null,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
        leading: Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: isCurrent
                ? primaryColor.withValues(alpha: 0.12)
                : surfaceColor.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: isCurrent
                ? primaryColor
                : surfaceColor.withValues(alpha: 0.5),
            size: 20.sp,
          ),
        ),
        title: Row(
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                color: isCurrent ? primaryColor : surfaceColor,
                fontFamily: "Cairo",
              ),
            ),
            SizedBox(width: 6.w),
            // مؤشر التعديل
            if (isModified)
              Tooltip(
                message: offset > 0 ? '+$offset دقيقة' : '$offset دقيقة',
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_rounded,
                        size: 10.sp,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        offset > 0 ? '+$offset' : '$offset',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 10.sp,
                          fontFamily: "Cairo",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الوقت
            Text(
              time,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                color: isCurrent ? primaryColor : surfaceColor,
                fontFamily: "Cairo",
              ),
            ),
            SizedBox(width: 8.w),
            // زر الإعدادات
            GestureDetector(
              onTap: () => _showAdjustmentDialog(context, name, offset),
              child: Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: surfaceColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  size: 16.sp,
                  color: isModified
                      ? Colors.orange
                      : surfaceColor.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // نافذة حوار تعديل الدقائق
  // ==========================================
  void _showAdjustmentDialog(
    BuildContext context,
    String prayerName,
    int currentOffset,
  ) {
    int tempOffset = currentOffset;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: context.color.surface,
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 30,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // مقبض
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    color: context.color.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),

                // العنوان
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: context.color.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: context.color.primary,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ضبط وقت $prayerName",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: context.color.onSurface,
                            fontFamily: "Cairo",
                          ),
                        ),
                        Text(
                          "الحد الأقصى ± 60 دقيقة",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: context.color.onSurface.withValues(
                              alpha: 0.5,
                            ),
                            fontFamily: "Cairo",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 28.h),

                // عرض القيمة الحالية
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 24.w,
                  ),
                  decoration: BoxDecoration(
                    color: tempOffset == 0
                        ? context.color.onSurface.withValues(alpha: 0.04)
                        : Colors.orange.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: tempOffset == 0
                          ? context.color.onSurface.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tempOffset >= 0
                            ? Icons.add_circle_outline
                            : Icons.remove_circle_outline,
                        color: tempOffset == 0
                            ? context.color.onSurface.withValues(alpha: 0.4)
                            : Colors.orange,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        tempOffset == 0
                            ? "لا يوجد تعديل"
                            : tempOffset > 0
                            ? "+$tempOffset دقيقة"
                            : "$tempOffset دقيقة",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: tempOffset == 0
                              ? context.color.onSurface.withValues(alpha: 0.4)
                              : Colors.orange,
                          fontFamily: "Cairo",
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // شريط التمرير (Slider)
                Column(
                  children: [
                    Slider(
                      value: tempOffset.toDouble(),
                      min: -60,
                      max: 60,
                      divisions: 120,
                      activeColor: context.color.primary,
                      inactiveColor: context.color.onSurface.withValues(
                        alpha: 0.12,
                      ),
                      thumbColor: context.color.primary,
                      onChanged: (val) {
                        setModalState(() => tempOffset = val.round());
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "-60",
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: context.color.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                          Text(
                            "0",
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: context.color.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                          Text(
                            "+60",
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: context.color.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // أزرار سريعة لقيم شائعة
                Wrap(
                  spacing: 8.w,
                  children: [-15, -10, -5, 0, 5, 10, 15].map((val) {
                    final isSelected = tempOffset == val;
                    return GestureDetector(
                      onTap: () => setModalState(() => tempOffset = val),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.color.primary
                              : context.color.onSurface.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: isSelected
                                ? context.color.primary
                                : context.color.onSurface.withValues(
                                    alpha: 0.15,
                                  ),
                          ),
                        ),
                        child: Text(
                          val == 0 ? "أصلي" : (val > 0 ? "+$val" : "$val"),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? context.color.onPrimary
                                : context.color.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 24.h),

                // أزرار الحفظ والإلغاء
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.color.onSurface,
                          side: BorderSide(
                            color: context.color.onSurface.withValues(
                              alpha: 0.2,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: Text(
                          "إلغاء",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: "Cairo",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ref
                              .read(prayerAdjustmentsProvider.notifier)
                              .updateOffset(prayerName, tempOffset);
                          // إعادة تحميل الأوقات مع الـ offset الجديد
                          ref.invalidate(selectedDatePrayerTimesProvider);
                          ref.invalidate(todayPrayerTimesProvider);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.color.primary,
                          foregroundColor: context.color.onPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: Text(
                          "حفظ التعديل",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: "Cairo",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // نافذة تأكيد إعادة تعيين جميع التعديلات
  // ==========================================
  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          "إعادة تعيين التعديلات",
          style: TextStyle(
            fontFamily: "Cairo",
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        content: Text(
          "هل تريد إعادة جميع أوقات الصلاة إلى أوقاتها الأصلية المحسوبة؟",
          style: TextStyle(fontFamily: "Cairo", fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "إلغاء",
              style: TextStyle(
                color: context.color.onSurface,
                fontFamily: "Cairo",
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(prayerAdjustmentsProvider.notifier).resetAllOffsets();
              ref.invalidate(selectedDatePrayerTimesProvider);
              ref.invalidate(todayPrayerTimesProvider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: const Text(
              "إعادة تعيين",
              style: TextStyle(
                fontFamily: "Cairo",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // حالة التحميل
  // ==========================================
  Widget _buildLoadingState(
    BuildContext context,
    Map<LocationMessage, String> status,
  ) {
    if (status.isNotEmpty &&
        status.keys.first == LocationMessage.locationAllowed) {
      return _buildSkeletonPrayerContent(context);
    }
    return _buildSkeletonPrayerContent(context);
  }

  // ==========================================
  // حالات الخطأ
  // ==========================================
  Widget _buildErrorState({
    required String error,
    required BuildContext context,
    required Map<LocationMessage, String> status,
    required NetworkInfoState networkState,
  }) {
    if (networkState == NetworkInfoState.loading) {
      return _buildSkeletonPrayerContent(context);
    }

    if (networkState == NetworkInfoState.notConnected) {
      return _buildNoInternetWidget();
    }

    if (status.isNotEmpty) {
      final messageType = status.keys.first;

      if (messageType == LocationMessage.locationDisabled ||
          messageType == LocationMessage.locationNotAllowed ||
          messageType == LocationMessage.locationNotAllowedEver) {
        return _buildActionErrorUI(context, status);
      }

      if (messageType == LocationMessage.loading) {
        return _buildSkeletonPrayerContent(context);
      }
    }

    if (status.isEmpty) {
      return _buildSkeletonPrayerContent(context);
    }

    if (status.keys.first == LocationMessage.locationAllowed) {
      return _buildSkeletonPrayerContent(context);
    }

    return _buildActionErrorUI(context, status, technicalError: error);
  }

  Widget _buildNoInternetWidget() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40.w),
        padding: EdgeInsets.all(30.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: 0.15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 64.r,
              color: context.color.error,
            ),
            SizedBox(height: 16.h),
            Text(
              "لا يوجد اتصال بالإنترنت",
              style: TextStyle(
                color: context.color.onSurface,
                fontSize: 18.sp,
                fontFamily: "Cairo",
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "سيتم التحديث تلقائياً عند عودة الاتصال",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.color.onSurface.withValues(alpha: 0.6),
                fontSize: 13.sp,
                fontFamily: "Cairo",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionErrorUI(
    BuildContext context,
    Map<LocationMessage, String> status, {
    String? technicalError,
  }) {
    final messageType = status.keys.first;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getErrorIcon(messageType),
                size: 80.r,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              SizedBox(height: 24.h),
              Text(
                messageType == LocationMessage.locationDisabled
                    ? "خدمة الموقع معطلة"
                    : messageType == LocationMessage.locationNotAllowed ||
                          messageType == LocationMessage.locationNotAllowedEver
                    ? "أذونات الموقع مطلوبة"
                    : "عذراً، حدث خطأ",
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
                child: Text(
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
              ),
              SizedBox(height: 30.h),
              _buildActionButtons(context, status),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getErrorIcon(LocationMessage message) {
    switch (message) {
      case LocationMessage.locationDisabled:
        return Icons.gps_off_rounded;
      case LocationMessage.locationNotAllowed:
      case LocationMessage.locationNotAllowedEver:
        return Icons.location_off_rounded;
      default:
        return Icons.error_outline_rounded;
    }
  }

  Widget _buildActionButtons(
    BuildContext context,
    Map<LocationMessage, String> status,
  ) {
    final messageType = status.keys.first;
    return messageType == LocationMessage.locationNotAllowedEver
        ? ElevatedButton.icon(
            onPressed: () async => await Geolocator.openAppSettings(),
            icon: const Icon(Icons.settings),
            label: const Text("فتح الإعدادات"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          )
        : Text(
            "سيتم التحديث تلقائياً عند تفعيل الـ GPS",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
              fontFamily: "Cairo",
            ),
          );
  }

  // ==========================================
  // دوال المساعدة للصلوات
  // ==========================================
  Future<void> _checkAndFetchLocation() async {
    final networkState = ref.read(networkInfoProvider);
    final userPos = ref.read(userPositionProvider);

    if (networkState == NetworkInfoState.connected && userPos == null) {
      final status = ref.read(locationStatusProvider);
      if (status.isEmpty) {
        ref.invalidate(selectedDatePrayerTimesProvider);
        ref.invalidate(todayPrayerTimesProvider);
        await ref.read(locationStatusProvider.notifier).refreshStatus();
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ref.read(locationStatusProvider.notifier).setStatus({
          LocationMessage.locationDisabled: "الـ GPS معطل، يرجى تفعيله",
        });
        return;
      }

      ref.read(locationStatusProvider.notifier).setStatus({
        LocationMessage.loading: "جاري تحديد موقعك الحالي...",
      });

      final locationLocator = sl<LocationLocatorImpl>();
      final pos = await locationLocator.determinePosition();

      pos.fold(
        (failure) {
          ref.read(locationStatusProvider.notifier).setStatus({
            LocationMessage.error: failure.message,
          });
        },
        (position) {
          ref.read(userPositionProvider.notifier).state = position;
          ref.read(locationStatusProvider.notifier).clearStatus();
        },
      );

      ref.invalidate(todayPrayerTimesProvider);
    }
  }

  bool _checkIfCurrent(String name, Prayer current) {
    if (name == "الفجر" && current == Prayer.fajr) return true;
    if (name == "الشروق" && current == Prayer.sunrise) return true;
    if (name == "الظهر" && current == Prayer.dhuhr) return true;
    if (name == "العصر" && current == Prayer.asr) return true;
    if (name == "المغرب" && current == Prayer.maghrib) return true;
    if (name == "العشاء" && current == Prayer.isha) return true;
    return false;
  }

  Prayer _nextPrayerFromEntity(PrayerTimesEntity entity) {
    final now = DateTime.now();
    if (now.isBefore(entity.fajr)) return Prayer.fajr;
    if (now.isBefore(entity.sunrise)) return Prayer.sunrise;
    if (now.isBefore(entity.dhuhr)) return Prayer.dhuhr;
    if (now.isBefore(entity.asr)) return Prayer.asr;
    if (now.isBefore(entity.maghrib)) return Prayer.maghrib;
    if (now.isBefore(entity.isha)) return Prayer.isha;
    return Prayer.fajr;
  }

  Prayer _currentPrayerFromEntity(PrayerTimesEntity entity) {
    final now = DateTime.now();
    if (now.isBefore(entity.fajr)) return Prayer.fajr;
    if (now.isBefore(entity.sunrise)) return Prayer.sunrise;
    if (now.isBefore(entity.dhuhr)) return Prayer.dhuhr;
    if (now.isBefore(entity.asr)) return Prayer.asr;
    if (now.isBefore(entity.maghrib)) return Prayer.maghrib;
    if (now.isBefore(entity.isha)) return Prayer.isha;
    return Prayer.isha;
  }

  DateTime _timeForPrayerFromEntity(PrayerTimesEntity entity, Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return entity.fajr;
      case Prayer.sunrise:
        return entity.sunrise;
      case Prayer.dhuhr:
        return entity.dhuhr;
      case Prayer.asr:
        return entity.asr;
      case Prayer.maghrib:
        return entity.maghrib;
      case Prayer.isha:
        return entity.isha;
      default:
        return entity.fajr;
    }
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
}
