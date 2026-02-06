import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/extensions/sizes_ext.dart';
import 'package:noor_quran/l10n/app_localizations.dart';
import 'package:noor_quran/utils/arabic_numbers.dart';
import 'package:noor_quran/view_models/providers/quran_providers/surah_names_provider.dart';

class QuranSelectMenu extends ConsumerStatefulWidget {
  final PageController pageController;
  final void Function(String) onSurahSelected;

  const QuranSelectMenu({
    super.key,
    required this.pageController,
    required this.onSurahSelected,
  });

  @override
  ConsumerState<QuranSelectMenu> createState() => _QuranSelectMenuState();
}

class _QuranSelectMenuState extends ConsumerState<QuranSelectMenu>
    with SingleTickerProviderStateMixin<QuranSelectMenu> {
  late AnimationController animation;

  /// كاش محلي للـ surahsNames لتقليل إعادة الوصول للـ provider
  late final List<SurahItem> cachedSurahs;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cachedSurahs = ref.read(surahsProvider); // نسخ البيانات مرة واحدة فقط
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.witdthScreen;
    final height = context.heightScreen;
    final theme = Theme.of(context).colorScheme;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: const Offset(0, 0),
      ).animate(animation),
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        elevation: 8,
        constraints: BoxConstraints(
          minWidth: width * 0.9.w,
          maxHeight: height * 0.7.h,
        ),
        titlePadding: EdgeInsets.all(20.r),
        contentPadding: EdgeInsets.symmetric(
          horizontal: width * 0.03.w,
          vertical: height * 0.001.h,
        ),
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.select_surah,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: width * 0.06.sp,
              fontWeight: FontWeight.w600,
              color: theme.onSurface,
            ),
          ),
        ),
        children: [
          SizedBox(
            height: height * 0.6.h,
            child: ListView.builder(
              itemCount: cachedSurahs.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final surah = cachedSurahs[index];
                final page = surah.pageIndex;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primary.withValues(alpha: 0.08),
                        blurRadius: 3,
                        offset: const Offset(1, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () {
                        Navigator.of(context).pop("clear");
                        widget.pageController.animateToPage(
                          page,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                        widget.onSurahSelected(surah.name);
                      },
                      splashColor: theme.primary.withValues(alpha: .1),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: theme.primary,
                          radius: width * 0.045,
                          child:
                              AppLocalizations.of(context)!.localeName == "ar"
                              ? Text(
                                  ArabicNumbers().convert(index + 1),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.surface,
                                    fontSize: width * 0.045,
                                  ),
                                )
                              : Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.surface,
                                    fontSize: width * 0.045,
                                  ),
                                ),
                        ),
                        title: Text(
                          surah.name,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'naskh',
                            fontSize: width * 0.052,
                            color: theme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: theme.primary,
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
