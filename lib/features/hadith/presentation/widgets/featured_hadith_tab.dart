import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/features/hadith/presentation/providers/hadith_provider.dart';
import 'package:noor_quran/features/hadith/presentation/widgets/hadith_modal_bottom.dart';

class FeaturedHadithsTab extends ConsumerWidget {
  const FeaturedHadithsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. مراقبة الـ Provider الذي يعيد AsyncValue
    final hadithState = ref.watch(hadithProvider);

    // 2. استخدام .when للتعامل مع الحالات الثلاث (بيانات، تحميل، خطأ)
    return hadithState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text("حدث خطأ: $error")),
      data: (allHadiths) {
        // 3. فلترة الأحاديث المميزة من قائمة البيانات الجاهزة
        final featuredHadiths = allHadiths.where((h) => h.isFeautred).toList();

        if (featuredHadiths.isEmpty) {
          return const Center(child: Text("لا توجد أحاديث مميزة حالياً"));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: featuredHadiths.length,
            itemBuilder: (context, index) {
              final hadith = featuredHadiths[index];
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
                        fontFamily: "Amiri",
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    subtitle: Text(
                      hadith.hadithNarrator,
                      style: TextStyle(
                        fontSize: context.witdthScreen * 0.035,
                        fontFamily: "Cairo",
                      ),
                    ),
                    leading: Text(
                      "${index + 1}",
                      style: TextStyle(fontSize: context.witdthScreen * 0.04),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        // استخدام notifier لتعديل الحالة
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
          ),
        );
      },
    );
  }
}