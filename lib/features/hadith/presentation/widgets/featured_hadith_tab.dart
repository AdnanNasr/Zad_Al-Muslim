import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/features/hadith/presentation/providers/hadith_provider.dart';
import 'package:noor_quran/features/hadith/presentation/providers/favorites_provider.dart';
import 'package:noor_quran/features/hadith/presentation/widgets/hadith_card.dart';
import 'package:noor_quran/features/hadith/presentation/widgets/hadith_modal_bottom.dart';

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
          return const Center(child: Text("لا توجد أحاديث مفضلة حالياً"));
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          itemCount: featuredHadiths.length,
          itemBuilder: (context, index) {
            final hadith = featuredHadiths[index];
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
    );
  }
}
