import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/extensions/sizes_ext.dart';
import 'package:zad_al_muslim/features/adkar/presentation/providers/adkar_provider.dart';
import 'package:zad_al_muslim/features/adkar/presentation/pages/adkar_details_page.dart';

class QuickAdkarStrip extends ConsumerWidget {
  const QuickAdkarStrip({super.key});

  // الأذكار الأكثر استخداماً (بأسمائها في JSON)
  static const List<Map<String, dynamic>> _quickItems = [
    {'category': 'أذكار الصباح والمساء', 'icon': Icons.wb_sunny_rounded},
    {'category': 'أذكار النوم', 'icon': Icons.bedtime_rounded},
    {'category': 'الأذكار بعد السلام من الصلاة', 'icon': Icons.mosque_rounded},
    {'category': 'أذكار الاستيقاظ من النوم', 'icon': Icons.alarm_rounded},
    {'category': 'دعاء الهم والحزن', 'icon': Icons.favorite_rounded},
    {'category': 'الاستغفار والتوبة', 'icon': Icons.auto_awesome_rounded},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adkarAsync = ref.watch(allAdkarProvider);
    final ThemeMode themeMode = ref.watch(themeProvider);
    final bool isDark = themeMode == ThemeMode.dark;

    return adkarAsync.when(
      data: (adkarList) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      color: context.color.onSurface,
                      size: 20.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "اختصارات الأذكار",
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
              SizedBox(height: 12.h),
              SizedBox(
                height: context.mediaQueryHeight * 0.065,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  itemCount: _quickItems.length,
                  separatorBuilder: (_, _) => SizedBox(width: 10.w),
                  itemBuilder: (context, index) {
                    final item = _quickItems[index];
                    final category = item['category'] as String;
                    final icon = item['icon'] as IconData;

                    // البحث عن الذكر المطابق
                    final adkar = adkarList.where(
                      (a) => a.category == category,
                    );

                    final categoryColors = _getColorDependsOnCategory(
                      category,
                      context,
                      isDark,
                    );
                    final bgColor = categoryColors["background"] as Color;
                    final contentColor = categoryColors["icon"] as Color;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: adkar.isNotEmpty
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AdkarDetailsPage(
                                      adkarEntity: adkar.first,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        borderRadius: BorderRadius.circular(25.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(25.r),
                            border: Border.all(
                              color: contentColor.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(icon, size: 18.sp, color: contentColor),
                              SizedBox(width: 8.w),
                              Text(
                                // اختصار الاسم إذا كان طويلاً
                                _shortenName(category),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: "Cairo",
                                  fontWeight: FontWeight.w700,
                                  color: contentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  String _shortenName(String name) {
    if (name.length > 20) {
      // اختصار بعض الأسماء الطويلة
      if (name.contains('الصباح والمساء')) return 'الصباح والمساء';
      if (name.contains('بعد السلام')) return 'بعد الصلاة';
      if (name.contains('الاستيقاظ')) return 'الاستيقاظ';
      if (name.contains('الاستغفار')) return 'الاستغفار';
      return name.substring(0, 18);
    }
    return name;
  }

  Map<String, Color> _getColorDependsOnCategory(
    String category,
    BuildContext context,
    bool isDark,
  ) {
    final Color primary = context.color.primary;

    final baseColor = /*primary.withValues(alpha: .1);*/ switch (category) {
      "أذكار الصباح والمساء" => primary.withValues(alpha: .1),
      "أذكار النوم" => primary.withValues(alpha: .2),
      "الأذكار بعد السلام من الصلاة" => primary.withValues(alpha: .3),
      "أذكار الاستيقاظ من النوم" => primary.withValues(alpha: .4),
      "دعاء الهم والحزن" => primary.withValues(alpha: .5),
      "الاستغفار والتوبة" => primary.withValues(alpha: .55),
      _ => primary, // القيمة الافتراضية
    };

    return {
      "background": baseColor,
      "icon": isDark
          ? (baseColor is MaterialColor
                ? baseColor.shade200
                : context.color.onPrimary.withValues(alpha: .85))
          : (baseColor is MaterialColor
                ? baseColor.shade900
                : context.color.scrim.withValues(alpha: 9)),
    };
  }
}
