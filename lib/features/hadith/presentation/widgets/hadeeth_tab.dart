import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/features/hadith/presentation/providers/hadith_provider.dart';
import 'package:noor_quran/features/hadith/presentation/widgets/filter_container.dart';
import 'package:noor_quran/features/hadith/presentation/widgets/hadith_card.dart';
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
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
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
                  SizedBox(width: 8.w),
                  FilterContainer(
                    title: "الراوي",
                    iconData: Icons.person_outline_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    options: [
                      "أبو هريرة",
                      "عمر بن الخطاب",
                      "علي بن ابي طالب",
                      "عائشة بنت خويلد",
                    ],
                  ),
                  SizedBox(width: 8.w),
                  FilterContainer(
                    title: "الموضوع",
                    iconData: Icons.category_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    options: ["الفرائض", "السنن", "النوافل", "المباحات"],
                  ),
                  SizedBox(width: 8.w),
                  FilterContainer(
                    title: "الدرجة",
                    iconData: Icons.grade,
                    color: Theme.of(context).colorScheme.primary,
                    options: ["صحيح", "حسن", "ضعيف"],
                  ),
                ],
              ),
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
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: hadiths.length,
                  itemBuilder: (context, index) {
                    final hadith = hadiths[index];
                    return HadithCard(
                      hadith: hadith,
                      index: index,
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
                      onToggleFavorite: () async {
                        await ref
                            .read(hadithProvider.notifier)
                            .toggleIsFeatured(hadith);
                      },
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            ref.read(hadithProvider.notifier).clearFilters();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Theme.of(context).colorScheme.error.withValues(alpha: .2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.filter_alt_off_outlined, 
                     size: 18.sp,
                     color: Theme.of(context).colorScheme.error),
                SizedBox(width: 8.w),
                Text(
                  "حذف كل الفلاتر",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.error,
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