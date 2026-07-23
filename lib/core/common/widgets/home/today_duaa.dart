import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zad_al_muslim/core/common/providers/daily_content_provider.dart';

class TodayDuaa extends ConsumerStatefulWidget {
  const TodayDuaa({super.key});

  @override
  ConsumerState<TodayDuaa> createState() => _TodayDuaaState();
}

class _TodayDuaaState extends ConsumerState<TodayDuaa> {
  Timer? _copiedMessageTimer;
  bool _showCopiedMessage = false;
  bool _isExpanded = false;

  @override
  void dispose() {
    _copiedMessageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duaaAsync = ref.watch(dailyDuaaProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Material(
        color: colorScheme.surface,
        elevation: isDark ? 0 : 3,
        shadowColor: Colors.black.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(24.r),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isDark
                  ? colorScheme.outlineVariant.withValues(alpha: 0.45)
                  : colorScheme.outline.withValues(alpha: 0.34),
            ),
          ),
          child: duaaAsync.when(
            data: (duaaText) {
              return _DuaaContent(
                duaaText: duaaText,
                showCopiedMessage: _showCopiedMessage,
                isExpanded: _isExpanded,
                onToggleExpanded: () {
                  setState(() => _isExpanded = !_isExpanded);
                },
                onCopy: () => _copyDuaa(duaaText),
                onShare: () => _shareDuaa(duaaText),
              );
            },
            loading: () => const _DuaaLoading(),
            error: (_, _) {
              return _DuaaError(
                onRetry: () {
                  ref.invalidate(dailyDuaaProvider);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _copyDuaa(String duaaText) async {
    final text = '$duaaText\n\nمن تطبيق زاد المسلم';

    await Clipboard.setData(ClipboardData(text: text));

    if (!mounted) return;

    _copiedMessageTimer?.cancel();

    setState(() {
      _showCopiedMessage = true;
    });

    _copiedMessageTimer = Timer(const Duration(milliseconds: 1600), () {
      if (!mounted) return;

      setState(() {
        _showCopiedMessage = false;
      });
    });
  }

  Future<void> _shareDuaa(String duaaText) async {
    await SharePlus.instance.share(
      ShareParams(text: '$duaaText\n\nمن تطبيق زاد المسلم'),
    );
  }
}

class _DuaaContent extends StatelessWidget {
  const _DuaaContent({
    required this.duaaText,
    required this.showCopiedMessage,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onCopy,
    required this.onShare,
  });

  final String duaaText;
  final bool showCopiedMessage;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final VoidCallback onCopy;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(18.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DuaaHeader(),

          SizedBox(height: 18.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  size: 26.sp,
                  color: colorScheme.primary.withValues(alpha: 0.65),
                ),

                SizedBox(height: 8.h),

                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    duaaText,
                    textAlign: TextAlign.center,
                    maxLines: isExpanded ? null : 5,
                    overflow: isExpanded ? null : TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      height: 1.8,
                    ),
                  ),
                ),

                if (duaaText.length > 150) ...[
                  SizedBox(height: 6.h),
                  TextButton.icon(
                    onPressed: onToggleExpanded,
                    icon: Icon(
                      isExpanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                    ),
                    label: Text(isExpanded ? 'عرض أقل' : 'عرض الدعاء كاملًا'),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 16.h),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  alignment: Alignment.topCenter,
                  child: child,
                ),
              );
            },
            child: showCopiedMessage
                ? const _CopiedMessage()
                : const SizedBox.shrink(key: ValueKey('hidden-copy-message')),
          ),

          if (showCopiedMessage) SizedBox(height: 10.h),

          Row(
            children: [
              Expanded(
                child: _DuaaActionButton(
                  icon: Icons.copy_rounded,
                  label: 'نسخ الدعاء',
                  onTap: onCopy,
                  isPrimary: true,
                ),
              ),

              SizedBox(width: 10.w),

              Expanded(
                child: _DuaaActionButton(
                  icon: Icons.share_rounded,
                  label: 'مشاركة',
                  onTap: onShare,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DuaaHeader extends StatelessWidget {
  const _DuaaHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 46.r,
          height: 46.r,
          decoration: BoxDecoration(
            color: colorScheme.tertiaryContainer.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Icon(
            Icons.volunteer_activism_rounded,
            size: 23.sp,
            color: colorScheme.onTertiaryContainer,
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'دعاء اليوم',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'دعاء مختار يتجدد كل يوم',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            'اليوم',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      ],
    );
  }
}

class _CopiedMessage extends StatelessWidget {
  const _CopiedMessage() : super(key: const ValueKey('visible-copy-message'));

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(13.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 17.sp,
            color: colorScheme.onPrimaryContainer,
          ),
          SizedBox(width: 7.w),
          Text(
            'تم نسخ الدعاء',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _DuaaActionButton extends StatelessWidget {
  const _DuaaActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final foregroundColor = isPrimary
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;

    final backgroundColor = isPrimary
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerLow;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(15.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.r),
        splashColor: colorScheme.primary.withValues(alpha: 0.08),
        highlightColor: colorScheme.primary.withValues(alpha: 0.04),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: isPrimary
                  ? colorScheme.primary.withValues(alpha: 0.16)
                  : colorScheme.outlineVariant.withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17.sp, color: foregroundColor),
              SizedBox(width: 7.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                    color: foregroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DuaaLoading extends StatelessWidget {
  const _DuaaLoading();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(18.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _LoadingBox(width: 46.r, height: 46.r, borderRadius: 15.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LoadingBox(width: 90.w, height: 13.h),
                    SizedBox(height: 7.h),
                    _LoadingBox(width: 145.w, height: 9.h),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Column(
              children: [
                _LoadingBox(width: 200.w, height: 12.h),
                SizedBox(height: 10.h),
                _LoadingBox(width: 230.w, height: 12.h),
                SizedBox(height: 10.h),
                _LoadingBox(width: 170.w, height: 12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingBox extends StatelessWidget {
  const _LoadingBox({
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius ?? 20.r),
      ),
    );
  }
}

class _DuaaError extends StatelessWidget {
  const _DuaaError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 26.h),
      child: Column(
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 32.sp,
            color: colorScheme.onSurfaceVariant,
          ),

          SizedBox(height: 10.h),

          Text(
            'تعذر تحميل دعاء اليوم',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 12.h),

          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
