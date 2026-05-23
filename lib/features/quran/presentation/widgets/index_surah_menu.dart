import 'package:zad_al_muslim/core/constants/surah_names.dart';
import "package:dartz/dartz.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:zad_al_muslim/core/common/providers/theme_provider.dart";
import "package:zad_al_muslim/core/errors/failures.dart";
import "package:zad_al_muslim/core/extensions/color_ext.dart";
import "package:zad_al_muslim/features/quran/data/models/juzz_model.dart";
import "package:zad_al_muslim/features/quran/domain/entities/surah_meta_entity.dart";
import "package:zad_al_muslim/features/quran/presentation/pages/quran_pages.dart";
import "package:zad_al_muslim/features/quran/presentation/providers/all_juzz_provider.dart";
import "package:zad_al_muslim/features/quran/presentation/providers/surahs_meta_provider.dart";
import "package:qcf_quran/qcf_quran.dart";

class IndexSurahMenu extends ConsumerStatefulWidget {
  const IndexSurahMenu({super.key});

  @override
  ConsumerState<IndexSurahMenu> createState() => _IndexSurahMenuState();
}

class _IndexSurahMenuState extends ConsumerState<IndexSurahMenu> {
  @override
  Widget build(BuildContext context) {
    final surahsMetaAsync = ref.watch(surahsMetaProvider);
    final juzzDataAsync = ref.watch(allJuzzProvider);

    final Color color = context.color.primary;

    final ThemeMode themeMode = ref.watch(themeProvider);
    final bool isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: context.color.primary.withValues(alpha: .02),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const SizedBox(height: 20),
              _IndexMenuTabBar(primaryColor: color),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: [
                    // التبويب الأول: السور
                    _buildSurahsTab(surahsMetaAsync, color, isDark),
                    // التبويب الثاني: الأجزاء
                    _buildAjzaTab(
                      surahsMetaAsync,
                      juzzDataAsync,
                      color,
                      isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSurahsTab(
    Either<Failure, List<SurahMetaEntity>> data,
    Color color,
    bool isDark,
  ) {
    return data.fold(
      (failure) => Center(child: Text(failure.message)),
      (list) => _SurahList(surahList: list, color: color, isDark: isDark),
    );
  }

  Widget _buildAjzaTab(
    Either<Failure, List<SurahMetaEntity>> surahsMeta,
    Either<Failure, List<JuzzModel>> juzzData,
    Color primary,
    bool isDark,
  ) {
    return _JuzList(
      primaryColor: primary,
      surahsMeta: surahsMeta,
      juzzData: juzzData,
      isDark: isDark,
    );
  }
}

// --- مكون التبويب العلوي ---
class _IndexMenuTabBar extends StatelessWidget {
  final Color primaryColor;
  const _IndexMenuTabBar({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.circular(8.dg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TabBar(
          splashBorderRadius: BorderRadius.circular(8.dg),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: primaryColor,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: context.color.onSurface,
          unselectedLabelStyle: TextStyle(
            fontSize: 14.sp,
            fontFamily: "Cairo",
            fontWeight: FontWeight.bold,
          ),
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Cairo",
            color: context.color.onPrimary,
            fontSize: 16.sp,
          ),
          tabs: const [
            Tab(text: "السور"),
            Tab(text: "الأجزاء"),
          ],
        ),
      ),
    );
  }
}

// --- قائمة السور ---
class _SurahList extends StatelessWidget {
  final List<SurahMetaEntity> surahList;
  final Color color;
  final bool isDark;
  const _SurahList({
    required this.surahList,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: surahList.length,
      itemBuilder: (context, index) {
        final surah = surahList[index];
        return Column(
          children: [
            _SurahCard(
              isDark: isDark,
              index: surah.surahNumber,
              surahName: 'surah${surah.surahNumber.toString().padLeft(3, '0')}',
              englishName: surah.englishName,
              primaryColor: color,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuranPages(pageNumber: surah.pageNumber),
                  ),
                );
              },
            ),
            if (index < surahList.length) SizedBox(height: 12.h),
          ],
        );
      },
    );
  }
}

// --- قائمة الأجزاء ---
class _JuzList extends StatelessWidget {
  final Either<Failure, List<SurahMetaEntity>> surahsMeta;
  final Either<Failure, List<JuzzModel>> juzzData;
  final Color primaryColor;
  final bool isDark;

  const _JuzList({
    required this.primaryColor,
    required this.surahsMeta,
    required this.juzzData,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return juzzData.fold((failure) => Center(child: Text(failure.message)), (
      data,
    ) {
      return surahsMeta.fold((failure) => Center(child: Text(failure.message)), (
        surahs,
      ) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final currentJuz = data[index];
            final surahNumber = currentJuz.versesEntity.verses.keys.first;
            final verseNumber =
                currentJuz.versesEntity.verses.values.first.first;

            return _JuzCard(
              isDark: isDark,
              index: currentJuz.id,
              partLabel: 'الجزء ${currentJuz.id}',
              partDescription:
                  'سورة ${SurahNames.getFormattedName(surahNumber)} - صفحة ${getPageNumber(surahNumber, verseNumber)}',
              partVerse: getVerse(
                surahNumber,
                verseNumber,
                verseEndSymbol: false,
              ),
              pageNumber: surahNumber,
              primaryColor: primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuranPages(
                      pageNumber: getPageNumber(surahNumber, verseNumber),
                    ),
                  ),
                );
              },
            );
          },
        );
      });
    });
  }
}

// --- بطاقة السورة ---
class _SurahCard extends StatelessWidget {
  final int index;
  final String surahName;
  final String englishName;
  final Color primaryColor;
  final VoidCallback onTap;
  final bool isDark;

  const _SurahCard({
    required this.index,
    required this.surahName,
    required this.englishName,
    required this.primaryColor,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: context.color.primary.withValues(alpha: .8),
          width: .5,
        ),
      ),
      child: ListTile(
        leading: _SurahIndexCircle(
          index: index,
          primaryColor: primaryColor,
          isDark: isDark,
        ),
        title: Text(
          surahName,
          style: TextStyle(
            fontFamily: 'surahname',
            package: 'qcf_quran',
            fontSize: 38.sp,
            color: context.color.onSurface,
          ),
        ),
        subtitle: Text(
          englishName,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: "Tajawal",
            fontWeight: FontWeight.w700,
            color: isDark
                ? context.color.onSurface.withValues(alpha: .85)
                : context.color.primary,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadiusGeometry.circular(15.r),
        ),
      ),
    );
  }
}

// --- بطاقة الجزء ---
class _JuzCard extends StatelessWidget {
  final int index;
  final String partLabel;
  final String partDescription;
  final String partVerse;
  final int pageNumber;
  final Color primaryColor;
  final VoidCallback onTap;
  final bool isDark;

  const _JuzCard({
    required this.index,
    required this.partLabel,
    required this.partDescription,
    required this.partVerse,
    required this.pageNumber,
    required this.primaryColor,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 6.h, right: 4.w, top: 10.h),
          child: Text(
            partLabel,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: "Cairo",
              fontWeight: FontWeight.bold,
              color: isDark ? context.color.onSurface : primaryColor,
            ),
          ),
        ),
        Ink(
          decoration: BoxDecoration(
            color: context.color.surface,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: context.color.primary.withValues(alpha: .8),
              width: .5,
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            leading: _SurahIndexCircle(
              index: index,
              primaryColor: primaryColor,
              isDark: isDark,
            ),
            title: Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                partVerse,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: "Quran",
                  fontSize: 20.sp,
                  height: 1.5.h,
                  color: context.color.onSurface,
                ),
                maxLines: 1,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Text(
                partDescription,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: "Tajawal",
                  color: isDark
                      ? context.color.onSurface.withValues(alpha: .7)
                      : context.color.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: Colors.grey[400],
            ),
            onTap: onTap,
            shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadiusGeometry.circular(15.r),
            ),
            splashColor: context.color.surface.withValues(alpha: .3),
          ),
        ),
      ],
    );
  }
}

// --- دائرة رقم الفهرس ---
class _SurahIndexCircle extends StatelessWidget {
  final int index;
  final Color primaryColor;
  final bool isDark;
  const _SurahIndexCircle({
    required this.index,
    required this.primaryColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
                  ? primaryColor.withValues(alpha: .3)
                  : primaryColor.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        Text(
          index.toString(),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? context.color.onSurface : primaryColor,
          ),
        ),
      ],
    );
  }
}
