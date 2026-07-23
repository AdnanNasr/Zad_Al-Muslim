import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/hadith/presentation/providers/hadith_provider.dart';
import 'package:zad_al_muslim/features/hadith/presentation/providers/favorites_provider.dart';
import 'package:zad_al_muslim/features/hadith/presentation/widgets/hadith_card.dart';
import 'package:zad_al_muslim/features/hadith/presentation/widgets/hadith_modal_bottom.dart';

class FeaturedHadithsTab extends ConsumerWidget {
  const FeaturedHadithsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);

    return favoritesState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text("حدث خطأ: $error")),
      data: (featuredHadiths) {
        if (featuredHadiths.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(28.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: context.color.secondaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star_border_rounded,
                      size: 42.sp,
                      color: context.color.onSecondaryContainer,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'مفضلتك بانتظارك',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: context.color.onSurface,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'اضغط على النجمة بجانب أي حديث لحفظه والعودة إليه بسهولة.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12.sp,
                      height: 1.6,
                      color: context.color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 24.h),
            itemCount: featuredHadiths.length,
            itemBuilder: (context, index) {
              final hadith = featuredHadiths[index];
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
                          backgroundColor: Colors.transparent,
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
        );
      },
    );
  }
}
