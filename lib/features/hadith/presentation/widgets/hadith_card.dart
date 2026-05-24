import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/hadith/domain/entities/hadith_entity.dart';
import 'package:zad_al_muslim/features/hadith/presentation/widgets/highlighted_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/features/hadith/presentation/providers/hadith_provider.dart';

class HadithCard extends ConsumerWidget {
  final HadithEntity hadith;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const HadithCard({
    super.key,
    required this.hadith,
    required this.index,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // تحسين الألوان: في الفاتح نستخدم لون خفيف جداً، وفي الداكن نستخدم درجة أفتح من الخلفية الأساسية
    final cardBackground = isDark
        ? colorScheme.surfaceContainerHigh
        : colorScheme.primary.withValues(alpha: 0.05);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.r),
          splashColor: context.color.primary.withValues(alpha: .1),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Decorative Number and Favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDecorativeNumber(context, index + 1),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          "كتاب ${hadith.bookName} • ${hadith.reference.hadith}",
                          style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onToggleFavorite,
                      icon: Icon(
                        hadith.isFavorite
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: Colors.amber.shade600,
                        size: 26.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Hadith Text with Highlight support
                Consumer(
                  builder: (context, ref, child) {
                    final searchQuery = ref
                        .watch(hadithProvider.notifier)
                        .currentSearchQuery;
                    return HighlightedText(
                      text: hadith.text,
                      highlight: searchQuery,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20.sp,
                        height: 1.8,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Naskh",
                        color: colorScheme.onSurface.withValues(alpha: 0.9),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativeNumber(BuildContext context, int number) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.brightness_7_rounded,
          size: 42.sp,
          color: colorScheme.primary.withValues(alpha: 0.15),
        ),
        Text(
          "$number",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
            fontFamily: "Cairo",
          ),
        ),
      ],
    );
  }
}
