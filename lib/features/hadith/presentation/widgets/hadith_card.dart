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
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: .05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22.r),
          splashColor: context.color.primary.withValues(alpha: .1),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Decorative Number and Favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDecorativeNumber(context, hadith.reference.hadith),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          'كتاب ${hadith.bookName}',
                          style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: hadith.isFavorite
                          ? 'إزالة من المفضلة'
                          : 'إضافة إلى المفضلة',
                      onPressed: onToggleFavorite,
                      icon: Icon(
                        hadith.isFavorite
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: colorScheme.secondary,
                        size: 22.sp,
                      ),
                    ),
                  ],
                ),
                Divider(height: 22.h, color: colorScheme.outlineVariant),

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
                        fontSize: 19.sp,
                        height: 1.75,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Naskh",
                        color: colorScheme.onSurface,
                      ),
                    );
                  },
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      size: 15.sp,
                      color: colorScheme.primary,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'اضغط لقراءة الحديث كاملاً',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10.5.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativeNumber(BuildContext context, int number) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      constraints: BoxConstraints(minWidth: 42.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        "$number",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: colorScheme.onTertiaryContainer,
          fontFamily: "Cairo",
        ),
      ),
    );
  }
}
