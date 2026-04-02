import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/constants/enums/my_enums.dart';
import 'package:noor_quran/features/hadith/domain/entities/hadith_entity.dart';
import 'package:share_plus/share_plus.dart';

class HadithModalBottom extends ConsumerWidget {
  final HadithEntity hadith;
  const HadithModalBottom({super.key, required this.hadith});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.only(
        top: 12.h,
        left: 20.w,
        right: 20.w,
        bottom: MediaQuery.of(context).padding.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(height: 24.h),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGradeBadge(hadith.grade),
              Row(
                children: [
                  _ActionButton(
                    icon: Icons.copy_rounded,
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text:
                              "${hadith.hadith}\n\nالراوي: ${hadith.hadithNarrator}\nالمصدر: ${hadith.book}",
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("تم نسخ الحديث إلى الحافظة"),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 12.w),
                  _ActionButton(
                    icon: Icons.share_rounded,
                    onTap: () {
                      Share.share(
                        "${hadith.hadith}\n\nالراوي: ${hadith.hadithNarrator}\nالمصدر: ${hadith.book}",
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Hadith Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SelectableText(
                      hadith.hadith,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.sp,
                        height: 2.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Naskh",
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Info Section
                  _InfoItem(
                    icon: Icons.person_outline_rounded,
                    title: "الراوي",
                    value: hadith.hadithNarrator,
                  ),
                  _InfoItem(
                    icon: Icons.book_outlined,
                    title: "المصدر",
                    value: hadith.book,
                  ),
                  _InfoItem(
                    icon: Icons.topic_outlined,
                    title: "الموضوع",
                    value: hadith.topic,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeBadge(HadithGrade grade) {
    Color gradeColor = Colors.grey;
    String gradeText = "غير معروف";

    switch (grade) {
      case HadithGrade.sahih:
        gradeColor = Colors.green;
        gradeText = "صحيح";
        break;
      case HadithGrade.hasan:
        gradeColor = Colors.orange;
        gradeText = "حسن";
        break;
      case HadithGrade.daif:
        gradeColor = Colors.red;
        gradeText = "ضعيف";
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: gradeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: gradeColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        gradeText,
        style: TextStyle(
          color: gradeColor,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
          fontFamily: "Cairo",
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          icon,
          size: 22.sp,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 20.sp, color: colorScheme.primary),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: "Cairo",
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                  fontFamily: "Cairo",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
