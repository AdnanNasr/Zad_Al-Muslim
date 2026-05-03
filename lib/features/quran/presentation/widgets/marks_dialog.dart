import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:zad_al_muslim/core/extensions/sizes_ext.dart';
import 'package:zad_al_muslim/core/l10n/app_localizations.dart';
import 'package:zad_al_muslim/core/utils/arabic_numbers.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/mark.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';

class MarksDialog extends ConsumerStatefulWidget {
  final PageController pageController;
  const MarksDialog({super.key, required this.pageController});

  @override
  ConsumerState<MarksDialog> createState() => _MarksDialogState();
}

class _MarksDialogState extends ConsumerState<MarksDialog> {
  @override
  Widget build(BuildContext context) {
    final markProvider = ref.watch(marksProvder);
    final theme = ref.watch(themeProvider);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: context.heightScreen * 0.02.r),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.saved_bookmarks,
              style: TextStyle(fontSize: context.witdthScreen * 0.05.sp),
            ),
            Padding(
              padding: EdgeInsets.all(8.0.r),
              child: markProvider.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: markProvider.length,
                      itemBuilder: (context, index) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            splashColor: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.15),
                            highlightColor: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.08),
                            onTap: () {
                              widget.pageController.animateToPage(
                                markProvider[index].pageNumber - 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.bounceIn,
                              );

                              Navigator.of(context).pop();
                            },

                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  child: Text(
                                    ArabicNumbers().convert(
                                      markProvider[index].pageNumber,
                                    ),
                                    style: TextStyle(
                                      fontSize: context.witdthScreen * 0.045,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "سُورَةُ ${markProvider[index].surahName}",
                                  style: TextStyle(
                                    fontSize: context.witdthScreen * 0.06,
                                    fontFamily: "Amiri",
                                  ),
                                ),
                                trailing: Text(
                                  DateFormat(
                                    'dd MMMM yyyy',
                                    AppLocalizations.of(context)!.localeName,
                                  ).format(markProvider[index].date),
                                  style: TextStyle(
                                    fontSize: context.witdthScreen * 0.04,
                                    fontFamily: "Cairo",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Column(
                      children: [
                        SizedBox(height: context.heightScreen * 0.05),
                        Center(
                          child: Text(
                            "لم يتم إضافة فواصل الى الآن",
                            style: TextStyle(
                              fontSize: context.witdthScreen * 0.05,
                              color: theme == ThemeMode.light
                                  ? Colors.black54
                                  : Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
