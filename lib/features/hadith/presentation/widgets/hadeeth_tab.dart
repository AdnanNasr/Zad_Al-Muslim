import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/features/hadith/presentation/providers/hadith_provider.dart';
import 'package:noor_quran/features/hadith/presentation/widgets/filter_container.dart';
import 'package:noor_quran/features/hadith/presentation/widgets/hadith_modal_bottom.dart';

class HadithTab extends ConsumerStatefulWidget {
  const HadithTab({super.key});

  @override
  ConsumerState<HadithTab> createState() => _HadithTabState();
}

class _HadithTabState extends ConsumerState<HadithTab> {
  @override
  Widget build(BuildContext context) {
    // 1. مراقبة الـ AsyncValue
    final hadithState = ref.watch(hadithProvider);
    // 2. الوصول للـ Notifier للتحقق من الفلاتر (نستخدم watch للمتابعة المستمرة)
    final notifier = ref.watch(hadithProvider.notifier);

    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // قسم الفلاتر (يبقى ثابتاً في الأعلى)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8.w,
              children: [
                FilterContainer(
                  title: "الكتاب",
                  iconData: Icons.book_outlined,
                  options: [
                    AppLocalizations.of(context)!.sahih_bukhari,
                    AppLocalizations.of(context)!.sahih_muslim,
                    AppLocalizations.of(context)!.sunan_abi_dawud,
                    AppLocalizations.of(context)!.sunan_at_tirmidhi,
                    AppLocalizations.of(context)!.sunan_an_nasai,
                    AppLocalizations.of(context)!.sunan_ibn_majah,
                  ],
                  color: Theme.of(context).colorScheme.primary,
                ),
                FilterContainer(
                  title: "الرواي",
                  iconData: Icons.person_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  options: [
                    "أبو هريرة",
                    "عمر بن الخطاب",
                    "علي بن ابي طالب",
                    "عائشة بنت خويلد",
                  ],
                ),
                FilterContainer(
                  title: "الموضوع",
                  iconData: Icons.category_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  options: ["الفرائض", "السنن", "النوافل", "المباحات"],
                ),
                FilterContainer(
                  title: "الدرجة",
                  iconData: Icons.grade,
                  color: Theme.of(context).colorScheme.primary,
                  options: ["صحيح", "حسن", "ضعيف"],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 10.h),

          // إظهار زر الحذف فقط عند وجود فلاتر نشطة
          if (!notifier.isFilterEmpty)
            ClearAllFilters(ref: ref),

          const SizedBox(height: 8),
          Divider(color: Theme.of(context).dividerColor, thickness: 2),
          const SizedBox(height: 8),

          // 3. معالجة القائمة بناءً على حالة الـ AsyncValue
          Expanded(
            child: hadithState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text("خطأ في تحميل الأحاديث: $err")),
              data: (hadiths) {
                if (hadiths.isEmpty) {
                  return const Center(child: Text("لا يوجد أحاديث في الوقت الحالي"));
                }
                
                return ListView.builder(
                  itemCount: hadiths.length,
                  itemBuilder: (context, index) {
                    final hadith = hadiths[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      color: Theme.of(context).cardColor,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isDismissible: true,
                            enableDrag: true,
                            showDragHandle: true,
                            useSafeArea: true,
                            isScrollControlled: true,
                            builder: (context) => HadithModalBottom(hadith: hadith),
                          );
                        },
                        child: ListTile(
                          title: Text(
                            hadith.hadith,
                            style: TextStyle(
                              fontSize: context.witdthScreen * 0.04,
                              fontFamily: "Cairo",
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                "الرواي:",
                                style: TextStyle(
                                  fontSize: context.witdthScreen * 0.038,
                                  fontFamily: "Cairo",
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                hadith.hadithNarrator,
                                style: TextStyle(
                                  fontSize: context.witdthScreen * 0.038,
                                  fontFamily: "Cairo",
                                ),
                              ),
                            ],
                          ),
                          leading: Text(
                            "${index + 1}",
                            style: TextStyle(fontSize: context.witdthScreen * 0.04),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await ref
                                  .read(hadithProvider.notifier)
                                  .toggleIsFeatured(hadith.hadith);
                            },
                            icon: Icon(
                              hadith.isFeautred ? Icons.star : Icons.star_border,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ClearAllFilters extends StatelessWidget {
  final WidgetRef ref;
  const ClearAllFilters({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          ref.read(hadithProvider.notifier).clearFilters();
        },
        child: Container(
          width: context.mediaQueryWidth * 0.44,
          height: context.mediaQueryHeight * 0.05,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.filter_alt_off_outlined, 
                     size: 18.sp,
                     color: Theme.of(context).colorScheme.error),
                SizedBox(width: 8.w),
                Text(
                  "حذف كل الفلاتر",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}