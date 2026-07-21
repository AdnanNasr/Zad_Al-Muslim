import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum DashboardCardSize { large, compact }

class DashboardCard extends StatefulWidget {
  const DashboardCard({
    super.key,
    required this.title,
    required this.iconImage,
    required this.accentColor,
    required this.onTap,
    this.label,
    this.value,
    this.footer,
    this.badge,
    this.size = DashboardCardSize.compact,
  });

  final String title;
  final String iconImage;
  final Color accentColor;
  final VoidCallback onTap;

  /// النص الصغير الذي يشرح القيمة.
  ///
  /// مثال: آخر قراءة، الصلاة القادمة، جاهزة للاستخدام.
  final String? label;

  /// القيمة الرئيسية داخل البطاقة.
  ///
  /// مثال: سورة الكهف، الفجر، أذكار الصباح.
  final String? value;

  /// الإجراء الموجود أسفل البطاقة.
  ///
  /// مثال: متابعة القراءة، عرض المواقيت.
  final String? footer;

  /// شارة اختيارية مثل: اليوم، جديد.
  final String? badge;

  final DashboardCardSize size;

  bool get isLarge => size == DashboardCardSize.large;

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? colorScheme.surfaceContainerLow
        : colorScheme.surface;

    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.40)
        : widget.accentColor.withValues(alpha: 0.13);

    return AnimatedScale(
      scale: _isPressed ? 0.985 : 1,
      duration: const Duration(milliseconds: 130),
      curve: Curves.easeOutCubic,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(
                alpha: isDark ? 0.10 : 0.045,
              ),
              blurRadius: isDark ? 8 : 18,
              offset: Offset(0, isDark ? 2 : 7),
            ),
          ],
        ),
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(22.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onTap();
            },
            onHighlightChanged: (value) {
              if (_isPressed == value) return;

              setState(() {
                _isPressed = value;
              });
            },
            splashColor: widget.accentColor.withValues(alpha: 0.08),
            highlightColor: widget.accentColor.withValues(alpha: 0.035),
            child: Ink(
              height: widget.isLarge ? 204.h : 186.h,
              padding: EdgeInsets.all(widget.isLarge ? 18.r : 14.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: widget.isLarge
                  ? _buildLargeLayout(context)
                  : _buildCompactLayout(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeLayout(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CardHeader(
          title: widget.title,
          iconImage: widget.iconImage,
          accentColor: widget.accentColor,
          badge: widget.badge,
          large: true,
        ),

        SizedBox(height: 18.h),

        if (widget.label != null)
          Text(
            widget.label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),

        if (widget.label != null && widget.value != null) SizedBox(height: 3.h),

        if (widget.value != null)
          Text(
            widget.value!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              height: 1.35,
            ),
          ),

        const Spacer(),

        if (widget.footer != null)
          _CardFooter(text: widget.footer!, accentColor: widget.accentColor),
      ],
    );
  }

  Widget _buildCompactLayout(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CardHeader(
          title: widget.title,
          iconImage: widget.iconImage,
          accentColor: widget.accentColor,
          badge: widget.badge,
          large: false,
        ),

        SizedBox(height: 16.h),

        if (widget.label != null)
          Text(
            widget.label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),

        if (widget.label != null && widget.value != null) SizedBox(height: 3.h),

        if (widget.value != null)
          Text(
            widget.value!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              height: 1.35,
            ),
          ),

        const Spacer(),

        if (widget.footer != null)
          _CardFooter(
            text: widget.footer!,
            accentColor: widget.accentColor,
            compact: true,
          ),
      ],
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.title,
    required this.iconImage,
    required this.accentColor,
    required this.large,
    this.badge,
  });

  final String title;
  final String iconImage;
  final Color accentColor;
  final String? badge;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: large ? 48.r : 40.r,
          height: large ? 48.r : 40.r,
          padding: EdgeInsets.all(large ? 9.r : 8.r),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(large ? 16.r : 13.r),
          ),
          child: Image.asset(
            iconImage,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) {
              return Icon(
                Icons.widgets_rounded,
                size: large ? 25.sp : 21.sp,
                color: accentColor,
              );
            },
          ),
        ),

        SizedBox(width: large ? 12.w : 9.w),

        Expanded(
          child: Text(
            title,
            maxLines: large ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: large ? 16.sp : 11.5.sp,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              height: 1.35,
            ),
          ),
        ),

        if (badge != null) ...[
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              badge!,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 8.sp,
                fontWeight: FontWeight.w700,
                color: accentColor,
                height: 1.2,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _CardFooter extends StatelessWidget {
  const _CardFooter({
    required this.text,
    required this.accentColor,
    this.compact = false,
  });

  final String text;
  final Color accentColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: compact ? 9.h : 11.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: compact ? 9.sp : 10.5.sp,
                fontWeight: FontWeight.w700,
                color: accentColor,
                height: 1.3,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.arrow_forward_rounded,
            size: compact ? 14.sp : 16.sp,
            color: accentColor,
          ),
        ],
      ),
    );
  }
}
