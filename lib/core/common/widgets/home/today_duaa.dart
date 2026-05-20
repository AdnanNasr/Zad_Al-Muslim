import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/common/providers/daily_content_provider.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';

class TodayDuaa extends ConsumerStatefulWidget {
  const TodayDuaa({
    super.key,
    required this.colorScheme,
    required this.themeMode,
  });
  final ColorScheme colorScheme;
  final ThemeMode themeMode;

  @override
  ConsumerState<TodayDuaa> createState() => _TodayDuaaState();
}

class _TodayDuaaState extends ConsumerState<TodayDuaa> {
  bool _showCopiedMessage = false;

  @override
  Widget build(BuildContext context) {
    final duaaAsync = ref.watch(dailyDuaaProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: context.color.primary.withValues(alpha: .08),
          border: Border.all(
            color: context.color.primary.withValues(alpha: 0.25),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 2.sp,
                    color: widget.colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0.r),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.volunteer_activism_rounded,
                        color: context.color.primary,
                        size: 22.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "دعاء اليوم",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: "Cairo",
                          fontWeight: FontWeight.bold,
                          color: context.color.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 2.sp,
                    color: widget.colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.h),
              child: duaaAsync.when(
                data: (duaaText) => Column(
                  children: [
                    Text(
                      "« $duaaText »",
                      style: TextStyle(
                        fontSize: 19.sp,
                        fontFamily: "Tajawal",
                        height: 1.6,
                        color: widget.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 18.h),
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 45.h,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: _showCopiedMessage ? 1.0 : 0.0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: context.color.primary,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                "تم النسخ",
                                style: TextStyle(
                                  color: context.color.onPrimary,
                                  fontSize: 14.sp,
                                  fontFamily: "Cairo",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        _buildActionButton(
                          icon: Icons.copy_rounded,
                          label: "نسخ",
                          color: context.color.onSurface,
                          iconColor: context.color.primary,
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: "$duaaText\n\nمن تطبيق زاد المسلم",
                              ),
                            );
                            _showCopiedMessage = true;
                            setState(() {});
                            Future.delayed(
                              const Duration(seconds: 1, milliseconds: 500),
                              () {
                                if (mounted) {
                                  setState(() => _showCopiedMessage = false);
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildActionButton({
  required IconData icon,
  required String label,
  required Color color,
  required Color iconColor,
  required VoidCallback onTap,
}) {
  return Tooltip(
    message: "نسخ الدعاء",
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18.sp, color: iconColor),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: "Cairo",
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
