import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/quran/data/models/juzz_model.dart';
import 'package:noor_quran/features/quran/presentation/pages/quran_pages.dart';
import 'package:noor_quran/features/quran/presentation/providers/all_juzz_provider.dart';
import 'package:noor_quran/features/quran/presentation/providers/surahs_meta_provider.dart';
import 'package:noor_quran/features/quran/domain/entities/surah_meta_entity.dart';
import 'package:noor_quran/core/common/constants/surah_names.dart';
import "package:qcf_quran/qcf_quran.dart";

class SelectSurahPage extends ConsumerStatefulWidget {
  const SelectSurahPage({super.key});

  @override
  ConsumerState<SelectSurahPage> createState() => _SelectSurahPageState();
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "فهرس المصحف",
          center: true,
          profile: false,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70.h),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: context.color.primary.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  color: context.color.onPrimary,
                  boxShadow: [
                    BoxShadow(
                      color: context.color.primary.withValues(alpha: .3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                labelColor: context.color.primary,
                unselectedLabelColor: context.color.onPrimary,
                labelStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Cairo",
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: "Cairo",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(text: "السور"),
                  Tab(text: "الأجزاء"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // التبويب الأول: قائمة السور
            _buildSurahTab(surahsMeta),

            // التبويب الثاني: قائمة الأجزاء (تم تعديلها لتشبه السور)
            _buildJuzTab(juzzData, surahsMeta),
          ],
        ),
      ),
    );
  }

  // --- بناء تبويب السور ---
  Widget _buildSurahTab(Either<Failure, List<SurahMetaEntity>> surahsMeta) {
    return surahsMeta.fold(
      (failure) => Center(
        child: Text(
          failure.message,
          style: const TextStyle(fontFamily: "Cairo", color: Colors.red),
        ),
      ),
      (surahs) => AnimationLimiter(
        child: Padding(
          padding: EdgeInsets.only(left: 4.w, top: 20.h, bottom: 20.h),
          child: Scrollbar(
            controller: _surahsScrollController,
            thumbVisibility: true,
            trackVisibility: true,
            interactive: true,
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
                      child: _buildSurahItem(context, surahs[index]),
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
  Widget _buildSurahItem(BuildContext context, SurahMetaEntity surah) {
    return _buildListTileContainer(
      context: context,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuranPages(pageNumber: surah.pageNumber),
          ),
        );
      },
      leading: _buildNumberIndicator(context, surah.surahNumber),
      title: Text(
        'surah${surah.surahNumber.toString().padLeft(3, '0')}',
        style: TextStyle(
          fontFamily: 'surahname',
          package: 'qcf_quran',
          fontSize: 45.sp,
          color: context.color.primary,
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
              color: Colors.grey[400],
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
                padding: EdgeInsets.only(left: 8.w, top: 20.h),
                child: Scrollbar(
                  controller: _juzzScrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  interactive: true,
                  thickness: 5,
                  radius: Radius.circular(24.r),
                  child: ListView.separated(
                    controller: _juzzScrollController,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
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
      leading: _buildNumberIndicator(context, juzNo),
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
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: context.color.primary.withValues(alpha: .2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.r),
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
                      color: context.color.primary.withValues(alpha: .2),
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
  Widget _buildNumberIndicator(BuildContext context, int number) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: 0.8,
          child: Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              color: context.color.primary.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        Text(
          number.toString(),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: context.color.primary,
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
          color: context.color.primary.withValues(alpha: .5),
          fontWeight: FontWeight.bold,
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5.sp,
            color: context.color.primary,
            fontWeight: FontWeight.bold,
            fontFamily: "Cairo",
          ),
        ),
      ],
    );
  }
}
