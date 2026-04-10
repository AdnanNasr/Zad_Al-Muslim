import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/common/providers/user_position_provider.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/core/utils/location/location_locator.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/features/qebla/presentation/providers/qibla_provider.dart';
import 'package:noor_quran/features/qebla/presentation/widgets/qibla_compass_painter.dart';

class QeblaPage extends ConsumerStatefulWidget {
  const QeblaPage({super.key});

  @override
  ConsumerState<QeblaPage> createState() => _QeblaPageState();
}

class _QeblaPageState extends ConsumerState<QeblaPage>
    with SingleTickerProviderStateMixin {
  // القيمة الحالية للزاوية — نُحوّلها إلى AnimationController لاحقاً
  double _currentAngle = 0.0;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  /// يُطلق طلب الإذن ثم يُحدّث الموضع في المزود
  Future<void> _requestLocation() async {
    final locationLocator = sl<LocationLocatorImpl>();
    final result = await locationLocator.determinePosition();
    result.fold(
      (failure) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message, style: const TextStyle(fontFamily: 'Cairo')),
            backgroundColor: Colors.red.shade700,
          ),
        );
      },
      (position) {
        ref.read(userPositionProvider.notifier).state = position;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final qiblaEntity = ref.watch(qiblaEntityProvider);
    final compassSupport = ref.watch(compassSupportProvider);
    final position = ref.watch(userPositionProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'اتجاه القبلة',
        center: false,
        profile: false,
      ),
      body: SafeArea(
        child: compassSupport.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _buildNoSensorState(context),
          data: (hasCompass) {
            if (!hasCompass) return _buildNoSensorState(context);
            if (position == null) return _buildNoLocationState(context);
            if (qiblaEntity == null) return _buildNoLocationState(context);

            return _buildCompassBody(context, qiblaEntity.qiblaAngle, qiblaEntity.distanceKm);
          },
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // الواجهة الرئيسية — البوصلة
  // ──────────────────────────────────────────────────────────

  Widget _buildCompassBody(
    BuildContext context,
    double qiblaAngle,
    double distanceKm,
  ) {
    return Column(
      children: [
        // -- رسالة التحذير المغناطيسي --
        _buildMagneticWarning(context),

        const Spacer(),

        // -- البوصلة --
        StreamBuilder<double?>(
          stream: ref.watch(compassStreamProvider),
          builder: (context, snapshot) {
            final heading = snapshot.data;

            if (heading == null) {
              return _buildCompassPlaceholder(context);
            }

            // زاوية السهم = القبلة (من الشمال) - اتجاه الجهاز الحالي
            final targetAngle = (qiblaAngle - heading) * math.pi / 180.0;

            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: _currentAngle, end: targetAngle),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              onEnd: () => _currentAngle = targetAngle,
              builder: (context, animatedAngle, _) {
                return _CompassWidget(
                  needleAngleRad: animatedAngle,
                  qiblaAngle: qiblaAngle,
                  heading: heading,
                );
              },
            );
          },
        ),

        const Spacer(),

        // -- بيانات إضافية: زاوية القبلة والمسافة --
        _buildInfoRow(context, qiblaAngle, distanceKm),

        SizedBox(height: 32.h),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────
  // تحذير المجالات المغناطيسية
  // ──────────────────────────────────────────────────────────

  Widget _buildMagneticWarning(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.amber.withValues(alpha: .4)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'للحصول على دقة أعلى، ابتعد عن المعادن والأجهزة الكهربائية',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12.sp,
                color: Colors.amber.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // صف المعلومات الإضافية
  // ──────────────────────────────────────────────────────────

  Widget _buildInfoRow(BuildContext context, double qiblaAngle, double distanceKm) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoChip(
            context,
            icon: Icons.explore_outlined,
            label: 'الزاوية',
            value: '${qiblaAngle.toStringAsFixed(1)}°',
          ),
          Container(
            width: 1,
            height: 40.h,
            color: context.color.onSurface.withValues(alpha: .1),
          ),
          _buildInfoChip(
            context,
            icon: Icons.straighten_outlined,
            label: 'المسافة للكعبة',
            value: '${(distanceKm / 1000).toStringAsFixed(0)} ألف كم',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: context.color.primary, size: 22.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: context.color.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11.sp,
            color: context.color.onSurface.withValues(alpha: .5),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────
  // حالة تحميل البوصلة
  // ──────────────────────────────────────────────────────────

  Widget _buildCompassPlaceholder(BuildContext context) {
    return SizedBox(
      width: 280.w,
      height: 280.w,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: context.color.primary),
            SizedBox(height: 16.h),
            Text(
              'جارٍ تحميل البوصلة…',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // حالة عدم وجود بوصلة
  // ──────────────────────────────────────────────────────────

  Widget _buildNoSensorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sensors_off_outlined,
              size: 72.sp,
              color: context.color.onSurface.withValues(alpha: .3),
            ),
            SizedBox(height: 24.h),
            Text(
              'المستشعر غير متوفر',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: context.color.onSurface,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'جهازك لا يحتوي على مستشعر مغناطيسي\n(Magnetometer) مطلوب لتحديد اتجاه البوصلة.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                color: context.color.onSurface.withValues(alpha: .55),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // حالة عدم وجود موقع
  // ──────────────────────────────────────────────────────────

  Widget _buildNoLocationState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 72.sp,
              color: context.color.onSurface.withValues(alpha: .3),
            ),
            SizedBox(height: 24.h),
            Text(
              'الموقع غير محدد',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: context.color.onSurface,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'يحتاج التطبيق إلى معرفة موقعك\nلحساب اتجاه القبلة بدقة.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                color: context.color.onSurface.withValues(alpha: .55),
                height: 1.6,
              ),
            ),
            SizedBox(height: 28.h),
            FilledButton.icon(
              onPressed: _requestLocation,
              icon: const Icon(Icons.my_location_rounded),
              label: const Text(
                'تحديد موقعي',
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// ويدجت البوصلة الداخلي
// ──────────────────────────────────────────────────────────────────────────────

class _CompassWidget extends StatelessWidget {
  final double needleAngleRad;
  final double qiblaAngle;
  final double heading;

  const _CompassWidget({
    required this.needleAngleRad,
    required this.qiblaAngle,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    final qiblaColor = const Color(0xFF4CAF50); // أخضر القبلة
    final ringColor = Theme.of(context).colorScheme.onSurface;
    final labelColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      children: [
        // -- مؤشر الاتجاه النصي --
        Text(
          _headingLabel(heading),
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .6),
          ),
        ),

        SizedBox(height: 16.h),

        // -- البوصلة --
        SizedBox(
          width: 260.w,
          height: 260.w,
          child: CustomPaint(
            painter: QiblaCompassPainter(
              needleAngleRad: needleAngleRad,
              qiblaColor: qiblaColor,
              ringColor: ringColor,
              labelColor: labelColor,
            ),
          ),
        ),

        SizedBox(height: 20.h),

        // -- badge القبلة --
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: qiblaColor.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: qiblaColor.withValues(alpha: .35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mosque_outlined, color: qiblaColor, size: 18.sp),
              SizedBox(width: 6.w),
              Text(
                'اتجاه القبلة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: qiblaColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _headingLabel(double heading) {
    final h = heading % 360;
    if (h < 22.5 || h >= 337.5) return 'شمال — ${h.toStringAsFixed(0)}°';
    if (h < 67.5) return 'شمال شرق — ${h.toStringAsFixed(0)}°';
    if (h < 112.5) return 'شرق — ${h.toStringAsFixed(0)}°';
    if (h < 157.5) return 'جنوب شرق — ${h.toStringAsFixed(0)}°';
    if (h < 202.5) return 'جنوب — ${h.toStringAsFixed(0)}°';
    if (h < 247.5) return 'جنوب غرب — ${h.toStringAsFixed(0)}°';
    if (h < 292.5) return 'غرب — ${h.toStringAsFixed(0)}°';
    return 'شمال غرب — ${h.toStringAsFixed(0)}°';
  }
}