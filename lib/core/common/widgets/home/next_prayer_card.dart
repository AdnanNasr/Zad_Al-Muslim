import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/constants/routes.dart';
import 'package:zad_al_muslim/features/pray_time/presentation/providers/next_prayer_provider.dart';
import 'package:zad_al_muslim/features/pray_time/presentation/providers/pray_times_provider.dart';

class NextPrayerCard extends ConsumerWidget {
  const NextPrayerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextPrayerAsync = ref.watch(nextPrayerProvider);

    return nextPrayerAsync.when(
      data: (nextPrayer) {
        if (nextPrayer == null) {
          return _PrayerCardError(
            message: 'لم يتم العثور على مواقيت الصلاة',
            onRetry: () {
              ref.invalidate(todayPrayerTimesProvider);
            },
          );
        }

        return _PrayerCardContent(nextPrayer: nextPrayer);
      },
      loading: () => const _PrayerCardLoading(),
      error: (_, _) {
        return _PrayerCardError(
          message: 'تعذر تحميل مواقيت الصلاة',
          onRetry: () {
            ref.invalidate(todayPrayerTimesProvider);
          },
        );
      },
    );
  }
}

class _PrayerCardContent extends StatefulWidget {
  const _PrayerCardContent({required this.nextPrayer});

  final NextPrayerInfo nextPrayer;

  @override
  State<_PrayerCardContent> createState() => _PrayerCardContentState();
}

class _PrayerCardContentState extends State<_PrayerCardContent> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final nextPrayer = widget.nextPrayer;

    final accentColor = nextPrayer.isVeryClose
        ? colorScheme.tertiary
        : colorScheme.primary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: AnimatedScale(
        scale: _isPressed ? 0.985 : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: Material(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(Routes.prayTimePage);
            },
            onHighlightChanged: (value) {
              if (_isPressed == value) return;

              setState(() {
                _isPressed = value;
              });
            },
            borderRadius: BorderRadius.circular(24.r),
            splashColor: accentColor.withValues(alpha: 0.08),
            highlightColor: accentColor.withValues(alpha: 0.04),
            child: Ink(
              padding: EdgeInsets.all(17.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: nextPrayer.isVeryClose
                      ? accentColor.withValues(alpha: 0.28)
                      : colorScheme.outlineVariant.withValues(alpha: 0.48),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PrayerCardHeader(
                    accentColor: accentColor,
                    isVeryClose: nextPrayer.isVeryClose,
                  ),

                  SizedBox(height: 18.h),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _PrayerIcon(
                        icon: nextPrayer.icon,
                        accentColor: accentColor,
                      ),

                      SizedBox(width: 13.w),

                      Expanded(
                        child: _PrayerMainInformation(
                          nextPrayer: nextPrayer,
                          accentColor: accentColor,
                        ),
                      ),

                      SizedBox(width: 10.w),

                      _PrayerTime(time: nextPrayer.formattedTime),
                    ],
                  ),

                  SizedBox(height: 17.h),

                  _CountdownSection(
                    nextPrayer: nextPrayer,
                    accentColor: accentColor,
                  ),

                  SizedBox(height: 14.h),

                  _OpenPrayerTimesAction(accentColor: accentColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrayerCardHeader extends StatelessWidget {
  const _PrayerCardHeader({
    required this.accentColor,
    required this.isVeryClose,
  });

  final Color accentColor;
  final bool isVeryClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mosque_rounded, size: 14.sp, color: accentColor),
              SizedBox(width: 5.w),
              Text(
                'الصلاة القادمة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        if (isVeryClose)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'اقترب الموعد',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 8.5.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onTertiaryContainer,
              ),
            ),
          )
        else
          Text(
            'مواقيت اليوم',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

class _PrayerIcon extends StatelessWidget {
  const _PrayerIcon({required this.icon, required this.accentColor});

  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54.r,
      height: 54.r,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Icon(icon, size: 28.sp, color: accentColor),
    );
  }
}

class _PrayerMainInformation extends StatelessWidget {
  const _PrayerMainInformation({
    required this.nextPrayer,
    required this.accentColor,
  });

  final NextPrayerInfo nextPrayer;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nextPrayer.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 21.sp,
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
            height: 1.25,
          ),
        ),

        SizedBox(height: 3.h),

        Text(
          nextPrayer.statusMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: nextPrayer.isVeryClose
                ? accentColor
                : colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _PrayerTime extends StatelessWidget {
  const _PrayerTime({required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'وقت الصلاة',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),

        SizedBox(height: 2.h),

        Text(
          time,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

class _CountdownSection extends StatelessWidget {
  const _CountdownSection({
    required this.nextPrayer,
    required this.accentColor,
  });

  final NextPrayerInfo nextPrayer;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: accentColor.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Icon(
              nextPrayer.isImminent
                  ? Icons.notifications_active_rounded
                  : Icons.timer_outlined,
              size: 18.sp,
              color: accentColor,
            ),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nextPrayer.isImminent ? 'موعد الصلاة' : 'متبقي على الصلاة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  nextPrayer.compactRemaining,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),

          Text(
            nextPrayer.digitalRemaining,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
              color: accentColor,
              letterSpacing: 0.7,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _OpenPrayerTimesAction extends StatelessWidget {
  const _OpenPrayerTimesAction({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          Icons.calendar_month_outlined,
          size: 17.sp,
          color: colorScheme.onSurfaceVariant,
        ),

        SizedBox(width: 7.w),

        Text(
          'عرض جميع مواقيت الصلاة',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurfaceVariant,
          ),
        ),

        const Spacer(),

        Container(
          width: 30.r,
          height: 30.r,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            size: 17.sp,
            color: accentColor,
          ),
        ),
      ],
    );
  }
}

class _PrayerCardLoading extends StatelessWidget {
  const _PrayerCardLoading();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(17.r),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.40),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LoadingBox(width: 95.w, height: 23.h, radius: 20.r),

            SizedBox(height: 18.h),

            Row(
              children: [
                _LoadingBox(width: 54.r, height: 54.r, radius: 18.r),

                SizedBox(width: 13.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LoadingBox(width: 60.w, height: 19.h),
                      SizedBox(height: 8.h),
                      _LoadingBox(width: 105.w, height: 10.h),
                    ],
                  ),
                ),

                _LoadingBox(width: 48.w, height: 20.h),
              ],
            ),

            SizedBox(height: 17.h),

            _LoadingBox(width: double.infinity, height: 58.h, radius: 17.r),

            SizedBox(height: 14.h),

            _LoadingBox(width: double.infinity, height: 30.h, radius: 10.r),
          ],
        ),
      ),
    );
  }
}

class _LoadingBox extends StatelessWidget {
  const _LoadingBox({required this.width, required this.height, this.radius});

  final double width;
  final double height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius ?? 20.r),
      ),
    );
  }
}

class _PrayerCardError extends StatelessWidget {
  const _PrayerCardError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer.withValues(alpha: 0.40),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: colorScheme.error.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Icon(
                Icons.location_off_outlined,
                size: 21.sp,
                color: colorScheme.error,
              ),
            ),

            SizedBox(width: 11.w),

            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),

            TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
          ],
        ),
      ),
    );
  }
}
