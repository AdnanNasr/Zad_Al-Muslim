import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:zad_al_muslim/core/constants/enums/my_enums.dart';
import 'package:zad_al_muslim/features/hadith/presentation/providers/hadith_provider.dart';
import 'package:zad_al_muslim/features/hadith/presentation/widgets/filter_container.dart';
import 'package:zad_al_muslim/features/hadith/presentation/widgets/hadith_search_bar.dart';
import 'package:zad_al_muslim/features/hadith/presentation/widgets/hadith_card.dart';
import 'package:zad_al_muslim/features/hadith/presentation/widgets/hadith_modal_bottom.dart';

class HadithTab extends ConsumerStatefulWidget {
  const HadithTab({super.key});

  @override
  ConsumerState<HadithTab> createState() => _HadithTabState();
}

class _HadithTabState extends ConsumerState<HadithTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(hadithProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hadithState = ref.watch(hadithProvider);
    final notifier = ref.watch(hadithProvider.notifier);

    // Smart Tags list defined by user
    final smartTags = [
      SahihBukhariBook.belief, // الإيمان
      SahihBukhariBook.salat, // الصلاة
      SahihBukhariBook.knowledge, // العلم
      SahihBukhariBook.salesAndTrade, // البيوع
      SahihBukhariBook.adab, // الأدب
      SahihBukhariBook.riqaq, // الرقاق
      SahihBukhariBook.invocations, // الدعوات
      SahihBukhariBook.tawheel, // التوحيد
    ];

    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Search Bar
          const HadithSearchBar(),
          SizedBox(height: 8.h),
          // Smart Tags
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 40.h),
            child: AnimationLimiter(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: smartTags.length,
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final tag = smartTags[index];
                  final isSelected = notifier.currentBookNumber == tag.id;
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 700),
                    child: SlideAnimation(
                      horizontalOffset: 40,
                      curve: Curves.ease,
                      child: FadeInAnimation(
                        child: ChoiceChip(
                          label: Text(
                            tag.arabicName,
                            style: TextStyle(
                              fontFamily: "Cairo",
                              fontSize: 13.sp,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            ref
                                .read(hadithProvider.notifier)
                                .setBook(selected ? tag.id : null);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Filters and Search (Future)
          Row(
            children: [
              const BookFilterContainer(
                title: "الكتاب",
                iconData: Icons.book_outlined,
              ),
              const Spacer(),
              if (!notifier.isFilterEmpty) const ClearAllFilters(),
            ],
          ),

          const SizedBox(height: 8),
          Divider(color: Theme.of(context).dividerColor, thickness: 2),
          const SizedBox(height: 8),

          Expanded(
            child: hadithState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text("خطأ في تحميل الأحاديث: $err")),
              data: (hadiths) {
                if (hadiths.isEmpty) {
                  return const Center(
                    child: Text("لا توجد أحاديث مطابقة للفلاتر"),
                  );
                }

                return Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  interactive: true,
                  radius: const Radius.circular(24),

                  child: AnimationLimiter(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemCount: hadiths.length + (notifier.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == hadiths.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final hadith = hadiths[index];
                        return AnimationConfiguration.staggeredList(
                          duration: const Duration(milliseconds: 700),
                          position: index,
                          child: SlideAnimation(
                            verticalOffset: 40,
                            child: FadeInAnimation(
                              child: HadithCard(
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
                                    builder: (context) =>
                                        HadithModalBottom(hadith: hadith),
                                  );
                                },
                                onToggleFavorite: () async {
                                  await ref
                                      .read(hadithProvider.notifier)
                                      .toggleIsFeatured(hadith);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ClearAllFilters extends ConsumerWidget {
  const ClearAllFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
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
            border: Border.all(
              color: Theme.of(context).colorScheme.error.withValues(alpha: .2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.filter_alt_off_outlined,
                size: 18.sp,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(width: 8.w),
              Text(
                "حذف الفلاتر",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
