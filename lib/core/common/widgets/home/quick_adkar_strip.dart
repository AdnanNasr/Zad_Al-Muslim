import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/features/adkar/domain/entities/adkar_entity.dart';
import 'package:zad_al_muslim/features/adkar/presentation/pages/adkar_details_page.dart';
import 'package:zad_al_muslim/features/adkar/presentation/providers/adkar_provider.dart';

class QuickAdkarStrip extends ConsumerWidget {
  const QuickAdkarStrip({super.key});

  static const List<_QuickAdkarItem> _quickItems = [
    _QuickAdkarItem(
      category: 'أذكار الصباح والمساء',
      shortTitle: 'الصباح والمساء',
      icon: Icons.wb_sunny_rounded,
      accent: _AdkarAccent.primary,
    ),
    _QuickAdkarItem(
      category: 'أذكار النوم',
      shortTitle: 'أذكار النوم',
      icon: Icons.bedtime_rounded,
      accent: _AdkarAccent.secondary,
    ),
    _QuickAdkarItem(
      category: 'الأذكار بعد السلام من الصلاة',
      shortTitle: 'بعد الصلاة',
      icon: Icons.mosque_rounded,
      accent: _AdkarAccent.tertiary,
    ),
    _QuickAdkarItem(
      category: 'أذكار الاستيقاظ من النوم',
      shortTitle: 'الاستيقاظ',
      icon: Icons.alarm_rounded,
      accent: _AdkarAccent.secondary,
    ),
    _QuickAdkarItem(
      category: 'دعاء الهم والحزن',
      shortTitle: 'الهم والحزن',
      icon: Icons.favorite_outline_rounded,
      accent: _AdkarAccent.tertiary,
    ),
    _QuickAdkarItem(
      category: 'الاستغفار والتوبة',
      shortTitle: 'الاستغفار',
      icon: Icons.auto_awesome_rounded,
      accent: _AdkarAccent.primary,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adkarAsync = ref.watch(allAdkarProvider);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: const _SectionHeader(),
          ),

          SizedBox(height: 12.h),

          adkarAsync.when(
            data: (adkarList) {
              final orderedItems = _getTimeAwareItems();

              return SizedBox(
                height: 78.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  itemCount: orderedItems.length,
                  separatorBuilder: (_, _) => SizedBox(width: 10.w),
                  itemBuilder: (context, index) {
                    final item = orderedItems[index];
                    final adkar = _findAdkar(
                      adkarList: adkarList,
                      category: item.category,
                    );

                    return _QuickAdkarCard(
                      item: item,
                      isAvailable: adkar != null,
                      isRecommended: index == 0,
                      onTap: adkar == null
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AdkarDetailsPage(adkarEntity: adkar),
                                ),
                              );
                            },
                    );
                  },
                ),
              );
            },
            loading: () => const _QuickAdkarLoading(),
            error: (_, _) => _QuickAdkarError(
              onRetry: () {
                ref.invalidate(allAdkarProvider);
              },
            ),
          ),
        ],
      ),
    );
  }

  AdkarEntity? _findAdkar({
    required List<AdkarEntity> adkarList,
    required String category,
  }) {
    for (final adkar in adkarList) {
      if (adkar.category.trim() == category.trim()) {
        return adkar;
      }
    }

    return null;
  }

  List<_QuickAdkarItem> _getTimeAwareItems() {
    final items = List<_QuickAdkarItem>.from(_quickItems);
    final hour = DateTime.now().hour;

    String preferredCategory;

    if (hour >= 4 && hour < 12) {
      preferredCategory = 'أذكار الصباح والمساء';
    } else if (hour >= 21 || hour < 4) {
      preferredCategory = 'أذكار النوم';
    } else {
      preferredCategory = 'الأذكار بعد السلام من الصلاة';
    }

    items.sort((first, second) {
      if (first.category == preferredCategory) return -1;
      if (second.category == preferredCategory) return 1;
      return 0;
    });

    return items;
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 38.r,
          height: 38.r,
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withValues(alpha: 0.70),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.bolt_rounded,
            size: 20.sp,
            color: colorScheme.onSecondaryContainer,
          ),
        ),

        SizedBox(width: 10.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختصارات الأذكار',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'وصول سريع إلى أذكارك اليومية',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        Icon(
          Icons.swipe_rounded,
          size: 19.sp,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.70),
        ),
      ],
    );
  }
}

class _QuickAdkarCard extends StatefulWidget {
  const _QuickAdkarCard({
    required this.item,
    required this.isAvailable,
    required this.isRecommended,
    required this.onTap,
  });

  final _QuickAdkarItem item;
  final bool isAvailable;
  final bool isRecommended;
  final VoidCallback? onTap;

  @override
  State<_QuickAdkarCard> createState() => _QuickAdkarCardState();
}

class _QuickAdkarCardState extends State<_QuickAdkarCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = _resolveAccentColor(colorScheme, widget.item.accent);

    final foregroundColor = widget.isAvailable
        ? colorScheme.onSurface
        : colorScheme.onSurfaceVariant.withValues(alpha: 0.50);

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (value) {
            if (_isPressed == value) return;

            setState(() {
              _isPressed = value;
            });
          },
          borderRadius: BorderRadius.circular(18.r),
          splashColor: accentColor.withValues(alpha: 0.08),
          highlightColor: accentColor.withValues(alpha: 0.04),
          child: Ink(
            width: 150.w,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: widget.isRecommended
                    ? accentColor.withValues(alpha: 0.35)
                    : colorScheme.outlineVariant.withValues(alpha: 0.45),
                width: widget.isRecommended ? 1.2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(
                      alpha: widget.isAvailable ? 0.12 : 0.05,
                    ),
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                  child: Icon(
                    widget.item.icon,
                    size: 21.sp,
                    color: widget.isAvailable
                        ? accentColor
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.40),
                  ),
                ),

                SizedBox(width: 10.w),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.shortTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w800,
                          color: foregroundColor,
                          height: 1.3,
                        ),
                      ),

                      SizedBox(height: 3.h),

                      Text(
                        widget.isAvailable
                            ? widget.isRecommended
                                  ? 'مقترح الآن'
                                  : 'فتح الذكر'
                            : 'غير متوفر',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: widget.isAvailable
                              ? widget.isRecommended
                                    ? accentColor
                                    : colorScheme.onSurfaceVariant
                              : colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.45,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveAccentColor(ColorScheme colorScheme, _AdkarAccent accent) {
    return switch (accent) {
      _AdkarAccent.primary => colorScheme.primary,
      _AdkarAccent.secondary => colorScheme.secondary,
      _AdkarAccent.tertiary => colorScheme.tertiary,
    };
  }
}

class _QuickAdkarLoading extends StatelessWidget {
  const _QuickAdkarLoading();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 78.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        itemCount: 3,
        separatorBuilder: (_, _) => SizedBox(width: 10.w),
        itemBuilder: (_, _) {
          return Container(
            width: 150.w,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LoadingLine(width: 68.w, height: 10.h),
                      SizedBox(height: 7.h),
                      _LoadingLine(width: 45.w, height: 8.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoadingLine extends StatelessWidget {
  const _LoadingLine({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }
}

class _QuickAdkarError extends StatelessWidget {
  const _QuickAdkarError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 20.sp,
              color: colorScheme.onErrorContainer,
            ),

            SizedBox(width: 9.w),

            Expanded(
              child: Text(
                'تعذر تحميل اختصارات الأذكار',
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

class _QuickAdkarItem {
  const _QuickAdkarItem({
    required this.category,
    required this.shortTitle,
    required this.icon,
    required this.accent,
  });

  final String category;
  final String shortTitle;
  final IconData icon;
  final _AdkarAccent accent;
}

enum _AdkarAccent { primary, secondary, tertiary }
