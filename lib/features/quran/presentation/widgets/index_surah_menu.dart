import "package:dartz/dartz.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:noor_quran/core/errors/failures.dart";
import "package:noor_quran/core/extensions/color_ext.dart";
import "package:noor_quran/features/quran/domain/entities/surah_meta_entity.dart";
import "package:noor_quran/features/quran/presentation/pages/quran_pages.dart";
import "package:noor_quran/features/quran/presentation/providers/surahs_meta_provider.dart";

class IndexSurahMenu extends ConsumerStatefulWidget {
  const IndexSurahMenu({super.key});

  @override
  ConsumerState<IndexSurahMenu> createState() => _IndexSurahMenuState();
}

class _IndexSurahMenuState extends ConsumerState<IndexSurahMenu> {
  // nice green color Color(0xFF006B54)
  // nice green bg color Color(0xFFF8F9FA)

  @override
  Widget build(BuildContext context) {
    final surahsMetaAsync = ref.watch(surahsMetaProvider);

    final Color primary = context.color.primary;
    final Color bgGrey = context.color.primaryContainer.withValues(alpha: .1);

    return Scaffold(
      backgroundColor: bgGrey,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const SizedBox(height: 60),
              _IndexMenuTabBar(primaryColor: primary),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildSurahsTab(surahsMetaAsync, primary),
                    _buildAjzaTab(surahsMetaAsync, primary),
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
    Color primary,
  ) {
    return data.fold(
      (failure) => const Center(child: Text("خطأ في تحميل البيانات")),
      (list) => _SurahList(surahList: list, primaryColor: primary),
    );
  }

  Widget _buildAjzaTab(
    Either<Failure, List<SurahMetaEntity>> data,
    Color primary,
  ) {
    return data.fold(
      (failure) => const Center(child: Text("خطأ في تحميل البيانات")),
      (list) => _JuzList(count: 30, primaryColor: primary),
    );
  }
}

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
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: primaryColor,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
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

class _SurahList extends StatelessWidget {
  final List<SurahMetaEntity> surahList;
  final Color primaryColor;

  const _SurahList({required this.surahList, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: surahList.length,
      itemBuilder: (context, i) {
        final surah = surahList[i];
        return _SurahCard(
          index: surah.pageNumber,
          surahName: 'surah${surah.surahNumber.toString().padLeft(3, '0')}',
          englishName: surah.englishName,
          primaryColor: primaryColor,
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => QuranPages(surahNumber: surah.pageNumber),
              ),
            );
          },
        );
      },
    );
  }
}

class _JuzList extends StatelessWidget {
  final int count;
  final Color primaryColor;

  const _JuzList({required this.count, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: count,
      itemBuilder: (context, i) {
        final juz = i + 1;
        return _JuzCard(
          index: juz,
          partLabel: 'الجزء $juz',
          partDescription: 'بداية من السورة ...',
          primaryColor: primaryColor,
          onTap: () {
            // TODO: navigate to juz start
          },
        );
      },
    );
  }
}

class _SurahCard extends StatelessWidget {
  final int index;
  final String surahName;
  final String englishName;
  final Color primaryColor;
  final VoidCallback onTap;

  const _SurahCard({
    required this.index,
    required this.surahName,
    required this.englishName,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withValues(alpha: .2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: _SurahIndexCircle(index: index, primaryColor: primaryColor),
        title: Text(
          surahName,
          style: TextStyle(
            fontFamily: 'surahname',
            package: 'qcf_quran',
            fontSize: 37.sp,
            color: primaryColor,
          ),
        ),
        subtitle: Text(englishName, style: TextStyle(fontSize: 14.sp)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}

class _JuzCard extends StatelessWidget {
  final int index;
  final String partLabel;
  final String partDescription;
  final Color primaryColor;
  final VoidCallback onTap;

  const _JuzCard({
    required this.index,
    required this.partLabel,
    required this.partDescription,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withValues(alpha: .2)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.r),
        leading: _SurahIndexCircle(index: index, primaryColor: primaryColor),
        title: Text(
          partLabel,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: primaryColor,
          ),
        ),
        subtitle: Text(partDescription, style: TextStyle(fontSize: 12.sp)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14.sp,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}

class _SurahIndexCircle extends StatelessWidget {
  final int index;
  final Color primaryColor;

  const _SurahIndexCircle({required this.index, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        '$index',
        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
