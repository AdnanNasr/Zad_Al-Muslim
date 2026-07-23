import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/errors/failures.dart';
import 'package:zad_al_muslim/features/quran/data/models/juzz_model.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/quran_pages.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/all_juzz_provider.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/surahs_meta_provider.dart';
import 'package:zad_al_muslim/features/quran/domain/entities/surah_meta_entity.dart';
import 'package:zad_al_muslim/core/constants/surah_names.dart';
import "package:qcf_quran/qcf_quran.dart";

class SelectSurahPage extends ConsumerStatefulWidget {
  const SelectSurahPage({super.key});

  @override
  ConsumerState<SelectSurahPage> createState() => _SelectSurahPageState();
}

class _QuranIndexHeader extends StatelessWidget {
  const _QuranIndexHeader();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 8.h),
      child: Row(
        children: [
          IconButton.filledTonal(
            tooltip: 'العودة',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
          SizedBox(width: 10.w),
          Container(
            width: 46.r,
            height: 46.r,
            decoration: BoxDecoration(
              color: scheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: scheme.onTertiaryContainer,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'فهرس المصحف',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  'اختر سورة أو جزءاً لبدء القراءة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10.5.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectSurahPageState extends ConsumerState<SelectSurahPage> {
  final ScrollController _surahsScrollController = ScrollController();
  final ScrollController _juzzScrollController = ScrollController();

  @override
  void dispose() {
    _surahsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surahsMeta = ref.watch(surahsMetaProvider);
    final juzzData = ref.watch(allJuzzProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: context.color.surfaceContainerLowest,
        body: SafeArea(
          child: Column(
            children: [
              const _QuranIndexHeader(),
              Container(
                height: 48.h,
                margin: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 4.h),
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: context.color.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: context.color.outlineVariant),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: context.color.surface,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  labelColor: context.color.primary,
                  unselectedLabelColor: context.color.onSurfaceVariant,
                  labelStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Cairo',
                  ),
                  tabs: const [
                    Tab(text: 'السور'),
                    Tab(text: 'الأجزاء'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildSurahTab(surahsMeta, isDark),
                    _buildJuzTab(juzzData, surahsMeta, isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- بناء تبويب السور ---
  Widget _buildSurahTab(
    Either<Failure, List<SurahMetaEntity>> surahsMeta,
    bool isDark,
  ) {
    return surahsMeta.fold(
      (failure) => Center(
        child: Text(
          failure.message,
          style: const TextStyle(fontFamily: "Cairo", color: Colors.red),
        ),
      ),
      (surahs) => AnimationLimiter(
        child: Padding(
          padding: EdgeInsets.only(top: 12.h, bottom: 20.h),
          child: Scrollbar(
            controller: _surahsScrollController,
            thumbVisibility: false,
            thickness: 5,
            radius: Radius.circular(24.r),
            child: ListView.separated(
              controller: _surahsScrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: surahs.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 700),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: _buildSurahItem(context, surahs[index], isDark),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // --- بناء عنصر السورة الواحد ---
  Widget _buildSurahItem(
    BuildContext context,
    SurahMetaEntity surah,
    bool isDark,
  ) {
    return _buildListTileContainer(
      context: context,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuranPages(pageNumber: surah.pageNumber),
          ),
        );
      },
      leading: _buildNumberIndicator(context, surah.surahNumber, isDark),
      title: Text(
        'surah${surah.surahNumber.toString().padLeft(3, '0')}',
        style: TextStyle(
          fontFamily: 'surahname',
          package: 'qcf_quran',
          fontSize: 40.sp,
          color: context.color.onSurface.withValues(alpha: .8),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            surah.englishName,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w300,
              color: context.color.onSurface.withValues(alpha: .7),
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              _buildInfoChip(
                Icons.menu_book_rounded,
                surah.verseCount >= 10
                    ? "${surah.verseCount} آية"
                    : "${surah.verseCount} آيات",
                context,
              ),
              SizedBox(width: 12.w),
              _buildInfoChip(
                Icons.grid_view_rounded,
                "الجزء ${surah.juzzNumber}",
                context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- بناء تبويب الأجزاء ---
  Widget _buildJuzTab(
    Either<Failure, List<JuzzModel>> juzz,
    Either<Failure, List<SurahMetaEntity>> surahsMeta,
    bool isDark,
  ) {
    return juzz.fold(
      (failure) {
        return Center(
          child: Text(
            failure.message,
            style: TextStyle(fontSize: 20.sp, fontFamily: "Cairo"),
          ),
        );
      },
      (data) {
        return surahsMeta.fold(
          (failure) {
            return Center(
              child: Text(failure.message, style: TextStyle(fontSize: 20.sp)),
            );
          },
          (surahsMeta) {
            return AnimationLimiter(
              child: Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Scrollbar(
                  controller: _juzzScrollController,
                  thumbVisibility: false,
                  thickness: 5,
                  radius: Radius.circular(24.r),
                  child: ListView.separated(
                    controller: _juzzScrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 18.h,
                    ),
                    itemCount: data.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final pageNumber =
                          data[index].versesEntity.verses.keys.first;
                      final verseNumber =
                          data[index].versesEntity.verses.values.first.first;
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 700),
                        child: SlideAnimation(
                          verticalOffset: 50,
                          child: FadeInAnimation(
                            child: _buildJuzItem(
                              context,
                              data[index].id,
                              SurahNames.getFormattedName(pageNumber),
                              getPageNumber(pageNumber, verseNumber),
                              getVerse(
                                pageNumber,
                                verseNumber,
                                verseEndSymbol: false,
                              ),
                              isDark,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- بناء عنصر الجزء الواحد (تم توحيده مع تصميم السور) ---
  Widget _buildJuzItem(
    BuildContext context,
    int juzNo,
    String surahName,
    int pageNumber,
    String verse,
    bool isDark,
  ) {
    return _buildListTileContainer(
      context: context,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return QuranPages(pageNumber: pageNumber);
            },
          ),
        );
      },
      juzzNumber: juzNo,
      leading: _buildNumberIndicator(context, juzNo, isDark),
      title: Text(
        verse,
        style: TextStyle(
          fontFamily: "Quran",
          fontSize: 19.sp,
          height: 2,
          color: context.color.onSurface.withValues(alpha: .9),
        ),
        maxLines: 1,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.h),
          Row(
            children: [
              _buildInfoChip(
                Icons.auto_stories_outlined,
                "سورة $surahName",
                context,
              ),
              SizedBox(width: 12.w),
              _buildInfoChip(
                Icons.tag_rounded,
                "صفحة رقم $pageNumber",
                context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- مكون مشترك للحاوية (Container) لتقليل تكرار الكود ---
  Widget _buildListTileContainer({
    required BuildContext context,
    required VoidCallback onTap,
    required Widget leading,
    required Widget title,
    required Widget subtitle,
    int? juzzNumber,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (juzzNumber != null)
          Text(
            "الجزء $juzzNumber",
            style: TextStyle(
              fontSize: 17.sp,
              fontFamily: "Cairo",
              fontWeight: FontWeight.bold,
              color: context.color.primary,
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: context.color.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: context.color.shadow.withValues(alpha: .05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20.r),
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(12.dg),
                child: Row(
                  children: [
                    leading,
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [title, subtitle],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14.sp,
                      color: context.color.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- مكون رقم السورة/الجزء ---
  Widget _buildNumberIndicator(BuildContext context, int number, bool isDark) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: 0.8,
          child: Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              color: isDark
                  ? context.color.primary.withValues(alpha: .3)
                  : context.color.primary.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        Text(
          number.toString(),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? context.color.onSurface : context.color.primary,
          ),
        ),
      ],
    );
  }

  // --- مكون المعلومات الصغيرة (Chip) ---
  Widget _buildInfoChip(IconData icon, String label, BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 13.sp,
          color: context.color.primary.withValues(alpha: .98),
          fontWeight: FontWeight.bold,
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5.sp,
            color: context.color.onSurface,
            fontWeight: FontWeight.bold,
            fontFamily: "Cairo",
          ),
        ),
      ],
    );
  }
}
