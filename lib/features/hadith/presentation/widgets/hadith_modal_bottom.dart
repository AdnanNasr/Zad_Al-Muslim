import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/features/hadith/domain/entities/hadith_entity.dart';
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
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(9.r),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  color: colorScheme.onTertiaryContainer,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'نص الحديث',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'صحيح البخاري',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ActionButton(
                    icon: Icons.copy_rounded,
                    showCopyFeedback: true,
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text:
                              "${hadith.text}\n\nصحيح البخاري | كتاب ${hadith.bookName} - حديث رقم ${hadith.reference.hadith}\n\nمن تطبيق زاد المسلم",
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 12.w),
                  _ActionButton(
                    icon: Icons.share_rounded,
                    onTap: () async {
                      SharePlus.instance.share(
                        ShareParams(
                          text:
                              "${hadith.text}\n\n📖 صحيح البخاري | كتاب ${hadith.bookName} - حديث رقم ${hadith.reference.hadith}\n\nمن تطبيق زاد المسلم",
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),

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
                      border: Border.all(color: colorScheme.outlineVariant),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      hadith.text,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 21.sp,
                        height: 1.75,
                        fontFamily: "Naskh",
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),

                  // Info Section
                  _InfoItem(
                    icon: Icons.book_outlined,
                    title: "الكتاب",
                    value: hadith.bookName,
                  ),
                  _InfoItem(
                    icon: Icons.numbers_rounded,
                    title: "رقم الحديث",
                    value: hadith.reference.hadith.toString(),
                  ),
                  const _InfoItem(
                    icon: Icons.verified_rounded,
                    title: 'المصدر',
                    value: 'صحيح البخاري',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool showCopyFeedback; // لتفعيل ميزة الرسالة فقط لزر النسخ

  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.showCopyFeedback = false,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _showCopiedMessage = false;

  void _handleTap() {
    widget.onTap();

    if (widget.showCopyFeedback) {
      setState(() => _showCopiedMessage = true);
      // إخفاء الرسالة بعد ثانية ونصف
      Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
        if (mounted) setState(() => _showCopiedMessage = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      alignment: Alignment.centerRight,
      clipBehavior: Clip.none,
      children: [
        // Container رسالة "تم النسخ"
        Positioned(
          left: 45.w, // يظهر بجانب الأيقونة من جهة اليمين (حسب اتجاه الـ Stack)
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _showCopiedMessage ? 1.0 : 0.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                "تم النسخ",
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 12.sp,
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // زر الأكشن الأساسي
        InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(widget.icon, size: 21.sp, color: colorScheme.primary),
          ),
        ),
      ],
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
              color: colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: colorScheme.onTertiaryContainer,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
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
          ),
        ],
      ),
    );
  }
}
