import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/extensions/sizes_ext.dart';
import 'package:noor_quran/view_models/providers/hadith_provider.dart';
import 'package:noor_quran/views/widgets/hadith_modal_bottom.dart';

class FeaturedHadithsTab extends ConsumerWidget {
  const FeaturedHadithsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hadiths = ref
        .watch(hadithProvider)
        .where((h) => h.isFeautred == true)
        .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: hadiths.length,
        itemBuilder: (context, index) {
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
                  builder: (context) {
                    return HadithModalBottom(hadith: hadiths[index]);
                  },
                );
              },
              child: ListTile(
                title: Text(
                  hadiths[index].hadith,
                  style: TextStyle(
                    fontSize: context.witdthScreen * 0.04,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
                subtitle: Text(
                  hadiths[index].hadithNarrator,
                  style: TextStyle(
                    fontSize: context.witdthScreen * 0.035,
                    fontFamily: "Rubik",
                  ),
                ),
                leading: Text(
                  "${index + 1}",
                  style: TextStyle(fontSize: context.witdthScreen * 0.04),
                ),
                trailing: IconButton(
                  onPressed: () async {
                    await ref
                        .read(hadithProvider.notifier)
                        .toggleIsFeautred(hadiths[index].hadith);
                  },
                  icon: Icon(
                    hadiths[index].isFeautred ? Icons.star : Icons.star_border,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
