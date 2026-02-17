import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/extensions/sizes_ext.dart';
import 'package:noor_quran/l10n/app_localizations.dart';
import 'package:noor_quran/view_models/providers/hadith_provider.dart';
import 'package:noor_quran/views/widgets/filter_container.dart';
import 'package:noor_quran/views/widgets/hadith_modal_bottom.dart';

class HadithTab extends ConsumerStatefulWidget {
  const HadithTab({super.key});

  @override
  ConsumerState<HadithTab> createState() => _HadithTabState();
}

class _HadithTabState extends ConsumerState<HadithTab> {
  // TODO: Complete Sunah and Hadith Page
  @override
  Widget build(BuildContext context) {
    final hadiths = ref.watch(hadithProvider);
    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
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
          if (ref.read(hadithProvider.notifier).isFilterEmpty())
            ClearAllFilters(ref: ref),
          const SizedBox(height: 8),
          Divider(color: Theme.of(context).dividerColor, thickness: 2),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: hadiths.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
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
                            hadiths[index].hadithNarrator,
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
                              .toggleIsFeautred(hadiths[index].hadith);
                        },
                        icon: Icon(
                          hadiths[index].isFeautred
                              ? Icons.star
                              : Icons.star_border,
                          color: Theme.of(context).primaryColor,
                        ),
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                SizedBox(width: 10.w),
                Text(
                  "حذف كل الفلاتر",
                  style: TextStyle(
                    fontSize: 17.sp,
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
