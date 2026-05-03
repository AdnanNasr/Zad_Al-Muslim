import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/quran/data/models/mark.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/quran_pages.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/mark.dart';

class MarksModalBottomSheet extends ConsumerWidget {
  const MarksModalBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marks = ref.watch(marksProvder);
    final primaryColor = context.color.primary;

    final pageMarks = marks.where((m) => m.ayahNumber == null).toList();
    final ayahMarks = marks.where((m) => m.ayahNumber != null).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              height: 4.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: .3),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),

            Text(
              "العلامات المحفوظة",
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: "Cairo",
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            SizedBox(height: 10.h),

            // TabBar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                height: 45.h,
                decoration: BoxDecoration(
                  color: context.color.primaryContainer.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TabBar(
                  splashBorderRadius: BorderRadius.circular(12.r),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: primaryColor,
                  ),
                  labelColor: context.color.onPrimary,
                  unselectedLabelColor: context.color.onSurface.withValues(
                    alpha: 0.6,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                  ),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Cairo",
                    fontSize: 15.sp,
                  ),
                  tabs: const [
                    Tab(text: "الصفحات"),
                    Tab(text: "الآيات"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10.h),

            Expanded(
              child: TabBarView(
                children: [
                  _MarkListView(
                    marks: pageMarks,
                    primaryColor: primaryColor,
                    isAyahList: false,
                  ),
                  _MarkListView(
                    marks: ayahMarks,
                    primaryColor: primaryColor,
                    isAyahList: true,
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

class _MarkListView extends ConsumerWidget {
  final List<Mark> marks;
  final Color primaryColor;
  final bool isAyahList;

  const _MarkListView({
    required this.marks,
    required this.primaryColor,
    required this.isAyahList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (marks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_outline_rounded,
              size: 60.sp,
              color: Colors.grey.withValues(alpha: .4),
            ),
            SizedBox(height: 10.h),
            Text(
              "لا توجد علامات محفوظة",
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: "Cairo",
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: marks.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final mark = marks[index];
        final formattedDate =
            "${mark.date.year}/${mark.date.month}/${mark.date.day}";

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: context.color.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.withValues(alpha: .15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .02),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
            leading: CircleAvatar(
              backgroundColor: primaryColor.withValues(alpha: .1),
              radius: 22.r,
              child: Icon(
                isAyahList
                    ? Icons.menu_book_rounded
                    : Icons.my_library_books_rounded,
                color: primaryColor,
                size: 20.sp,
              ),
            ),
            title: Text(
              isAyahList ? "سورة ${mark.surahName}" : "سورة ${mark.surahName}",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: context.color.onSurface,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Text(
                  isAyahList
                      ? "الآية ${mark.ayahNumber} - صفحة ${mark.pageNumber}"
                      : "صفحة ${mark.pageNumber}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: "Cairo",
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "تاريخ الحفظ: $formattedDate",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: "Cairo",
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: Colors.red[300]),
              onPressed: () async {
                final notifier = ref.read(marksProvder.notifier);
                if (isAyahList) {
                  await notifier.removeAyahMark(
                    mark.surahNumber!,
                    mark.ayahNumber!,
                  );
                } else {
                  await notifier.removeMark(mark.pageNumber);
                }
              },
            ),
            onTap: () {
              Navigator.pop(context); // Close the bottom sheet
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => QuranPages(
                    pageNumber: mark.pageNumber,
                    highlightSurah: mark.surahNumber,
                    highlightVerse: mark.ayahNumber,
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
