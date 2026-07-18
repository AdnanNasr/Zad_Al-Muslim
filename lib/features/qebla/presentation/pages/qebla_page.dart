import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/common/providers/user_position_provider.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/common/widgets/custom_app_bar.dart';
import 'package:zad_al_muslim/core/utils/location/location_locator.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/features/qebla/presentation/providers/qibla_provider.dart';
import 'package:zad_al_muslim/features/qebla/presentation/widgets/qibla_compass_painter.dart';

class QeblaPage extends ConsumerStatefulWidget {
  const QeblaPage({super.key});

  @override
  ConsumerState<QeblaPage> createState() => _QeblaPageState();
}

class _QeblaPageState extends ConsumerState<QeblaPage> {
  bool _isAligned = false;

  void _checkAlignment(double heading, double qiblaAngle) {
    double diff = (heading - qiblaAngle).abs();
    if (diff > 180) {
      diff = 360 - diff;
    }

    // يعتبر متطابقاً إذا كان الفرق أقل من أو يساوي درجتين
    final isNowAligned = diff <= 2.0;

    if (isNowAligned && !_isAligned) {
      HapticFeedback.heavyImpact(); // اهتزاز عند المطابقة
      if (mounted) setState(() => _isAligned = true);
    } else if (!isNowAligned && _isAligned) {
      if (mounted) setState(() => _isAligned = false);
    }
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
            content: Text(
              failure.message,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
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

    // متابعة البوصلة لمعرفة التوافق مع القبلة لأجل الاهتزاز
    ref.listen<AsyncValue<double?>>(compassStreamProvider, (previous, next) {
      final h = next.value;
      if (h != null && qiblaEntity != null) {
        _checkAlignment(h, qiblaEntity.qiblaAngle);
      }
    });

    return Scaffold(
      appBar: const CustomAppBar(title: 'اتجاه القبلة', center: false),
      body: SafeArea(
        child: compassSupport.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _buildNoSensorState(context),
          data: (hasCompass) {
            if (!hasCompass) return _buildNoSensorState(context);
            if (position == null) return _buildNoLocationState(context);
            if (qiblaEntity == null) return _buildNoLocationState(context);

            return _buildCompassBody(
              context,
              qiblaEntity.qiblaAngle,
              qiblaEntity.distanceKm,
            );
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
        // -- البوصلة --
        Consumer(
          builder: (context, ref, _) {
            final compassAsync = ref.watch(compassStreamProvider);
            final heading = compassAsync.value;

            if (heading == null) {
              return _buildCompassPlaceholder(context);
            }

            return _CompassWidget(
              needleAngleRad: qiblaAngle * (math.pi / 180.0),
              qiblaAngle: qiblaAngle,
              heading: heading,
              isAligned: _isAligned,
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
        color: context.color.primary.withValues(alpha: .03),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.color.primary.withValues(alpha: .4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: context.color.primary,
            size: 25.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              "للحصول على أعلى دقة، يرجى الأبتعاد عن الأجهزة الكهربائية والمجالات الكهرومغناطيسية.",
              style: TextStyle(fontSize: 15.sp, color: context.color.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // صف المعلومات الإضافية
  // ──────────────────────────────────────────────────────────

  Widget _buildInfoRow(
    BuildContext context,
    double qiblaAngle,
    double distanceKm,
  ) {
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
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: context.color.onSurface.withValues(alpha: .7),
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
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
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
  final bool isAligned; // To highlight compass when aligned

  const _CompassWidget({
    required this.needleAngleRad,
    required this.qiblaAngle,
    required this.heading,
    required this.isAligned,
  });

  @override
  Widget build(BuildContext context) {
    final qiblaColor = isAligned ? Colors.amber : context.color.primary;
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
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .6),
          ),
        ),

        SizedBox(height: 16.h),

        // -- البوصلة --
        Transform.rotate(
          angle: -heading * (math.pi / 180.0),
          child: SizedBox(
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
        ),

        SizedBox(height: 20.h),

        // -- badge القبلة --
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: context.color.primary.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: qiblaColor.withValues(alpha: .35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.mosque_outlined,
                color: context.color.primary,
                size: 18.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                'اتجاه القبلة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: context.color.primary,
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
