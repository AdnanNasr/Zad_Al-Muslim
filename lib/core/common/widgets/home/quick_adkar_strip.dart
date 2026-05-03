import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
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

    return adkarAsync.when(
      data: (adkarList) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      color: context.color.primary,
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
                height: 46.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  itemCount: _quickItems.length,
                  separatorBuilder: (_, __) => SizedBox(width: 10.w),
                  itemBuilder: (context, index) {
                    final item = _quickItems[index];
                    final category = item['category'] as String;
                    final icon = item['icon'] as IconData;

                    // البحث عن الذكر المطابق
                    final adkar = adkarList.where(
                      (a) => a.category == category,
                    );

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
                            color: context.color.primary.withValues(
                              alpha: 0.08,
                            ),
                            borderRadius: BorderRadius.circular(25.r),
                            border: Border.all(
                              color: context.color.primary.withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                icon,
                                size: 18.sp,
                                color: context.color.primary,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                // اختصار الاسم إذا كان طويلاً
                                _shortenName(category),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: "Cairo",
                                  fontWeight: FontWeight.w600,
                                  color: context.color.primary,
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
      error: (_, __) => const SizedBox.shrink(),
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
}
