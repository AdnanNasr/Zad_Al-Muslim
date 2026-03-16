import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/quran/presentation/pages/quran_pages.dart';
import 'package:noor_quran/features/quran/presentation/providers/surahs_meta_provider.dart';
import 'package:noor_quran/features/quran/domain/entities/surah_meta_entity.dart';

class SelectSurahPage extends ConsumerStatefulWidget {
  const SelectSurahPage({super.key});

  @override
  ConsumerState<SelectSurahPage> createState() => _SelectSurahPageState();
}

class _SelectSurahPageState extends ConsumerState<SelectSurahPage> {
  @override
  Widget build(BuildContext context) {
    final surahsMeta = ref.watch(surahsMetaProvider);

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
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Cairo",
                ),
                unselectedLabelStyle: TextStyle(fontFamily: "Cairo"),
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

            // التبويب الثاني: شبكة الأجزاء
            _buildJuzTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahTab(Either<Failure, List<SurahMetaEntity>> surahsMeta) {
    return surahsMeta.fold(
      (failure) => Center(
        child: Text(
          failure.message,
          style: TextStyle(fontFamily: "Cairo", color: Colors.red),
        ),
      ),
      (surahs) => AnimationLimiter(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
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
    );
  }

  Widget _buildSurahItem(BuildContext context, SurahMetaEntity surah) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.color.primary.withValues(alpha: .05)),
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
          onTap: () {
            print(surah.pageNumber);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuranPages(surahNumber: surah.pageNumber),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(12.dg),
            child: Row(
              children: [
                // تصميم رقم السورة
                _buildSurahNumberIndicator(context, surah.surahNumber),
                SizedBox(width: 16.w),

                // تفاصيل السورة
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'surah${surah.surahNumber.toString().padLeft(3, '0')}',
                        style: TextStyle(
                          fontFamily: 'surahname',
                          package: 'qcf_quran',
                          fontSize: 38.sp,
                          color: context.color.primary,
                        ),
                      ),
                      // اسم السورة بالإنجليزي
                      Text(
                        surah.englishName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // معلومات إضافية (آياتها، الجزء)
                      Row(
                        children: [
                          _buildInfoChip(
                            Icons.menu_book_rounded,
                            "${surah.verseCount} آية",
                          ),
                          SizedBox(width: 12.w),
                          _buildInfoChip(
                            Icons.grid_view_rounded,
                            "الجزء ${surah.juzzNumber}",
                          ),
                        ],
                      ),
                    ],
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
    );
  }

  Widget _buildSurahNumberIndicator(BuildContext context, int number) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // شكل إسلامي مبسط كخلفية للرقم
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

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 12.sp, color: Colors.grey[400]),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey[600],
            fontFamily: "Cairo",
          ),
        ),
      ],
    );
  }

  Widget _buildJuzTab() {
    return AnimationLimiter(
      child: GridView.builder(
        padding: EdgeInsets.all(16.dg),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // عرض 3 أجزاء في الصف الواحد
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 1,
        ),
        itemCount: 30,
        itemBuilder: (context, index) {
          final int juzNo = index + 1;
          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: 3,
            child: SlideAnimation(
              verticalOffset: 20,
              duration: Duration(milliseconds: 900),
              child: FadeInAnimation(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: context.color.primary.withValues(alpha: .1),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.r),
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "جزء",
                            style: TextStyle(
                              fontFamily: "Cairo",
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            juzNo.toString(),
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: context.color.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
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
