import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/constants/routes.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/providers/selected_book.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/providers/tafsser_book.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/providers/tafsser_provider.dart';

Future<dynamic> showTafsserModalBottom(
  BuildContext context,
  WidgetRef ref,
  int surahNumber,
  int verseNumber,
  String bookId,
) async {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final Color bgColor = context.color.surfaceContainerLowest;
  final Color surfaceContainer = context.color.surface;
  final Color textColor = context.color.onSurface;
  final Color primaryColor = context.color.primary;

  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // لجعل الحواف العلوية تعمل بشكل صحيح
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          final selectedBook = ref.watch(selectedBookProvider);
          final booksAsync = ref.watch(tafsserBookProvider);

          return Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              boxShadow: [
                BoxShadow(
                  color: context.color.shadow.withValues(alpha: 0.14),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.5,
                maxChildSize: 0.9,
                minChildSize: 0.4,
                builder: (context, scrollController) {
                  return CustomScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // الهيدر الثابت (Pinned)
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _StickyHeaderDelegate(
                          height: 110,
                          child: Container(
                            color: bgColor,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Center(child: _buildHandle(isDarkMode)),

                                // الهيدر: العنوان واختيار الكتاب
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "تفسير الآية $verseNumber",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.sp,
                                          fontFamily: 'Cairo',
                                          color: primaryColor,
                                        ),
                                      ),

                                      // اختيار التفسير
                                      MenuAnchor(
                                        key: ValueKey(
                                          booksAsync.value?.length ?? 0,
                                        ),
                                        style: MenuStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                isDarkMode
                                                    ? const Color(0xFF2C2C2C)
                                                    : Colors.white,
                                              ),
                                          shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                            ),
                                          ),
                                          elevation: WidgetStateProperty.all(4),
                                        ),
                                        builder: (context, controller, child) {
                                          return OutlinedButton.icon(
                                            onPressed: () => controller.isOpen
                                                ? controller.close()
                                                : controller.open(),
                                            label: Text(
                                              selectedBook.name,
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            icon: const Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              size: 20,
                                            ),
                                            style: _buttonStyle(
                                              context,
                                              isDarkMode,
                                            ),
                                          );
                                        },
                                        menuChildren: booksAsync.when(
                                          data: (booksOrFailure) => booksOrFailure.fold(
                                            (failure) => [
                                              Padding(
                                                padding: EdgeInsets.all(12.r),
                                                child: Text(
                                                  failure.message,
                                                  style: const TextStyle(
                                                    fontFamily: 'Cairo',
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            (books) {
                                              //  تصفية الكتب المحملة فقط
                                              final downloadedBooks = books
                                                  .where(
                                                    (book) => book.isDownloaded,
                                                  )
                                                  .toList();

                                              return [
                                                //  عرض الكتب المحملة مع فواصل بينها
                                                for (final (index, book)
                                                    in downloadedBooks
                                                        .indexed) ...[
                                                  MenuItemButton(
                                                    onPressed: () => ref
                                                        .read(
                                                          selectedBookProvider
                                                              .notifier,
                                                        )
                                                        .updateSelectedBook(
                                                          book,
                                                        ),
                                                    child: Text(
                                                      book.name,
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: 14.sp,
                                                        color:
                                                            selectedBook.id ==
                                                                book.id
                                                            ? primaryColor
                                                            : null,
                                                      ),
                                                    ),
                                                  ),
                                                  //  فاصل فقط إذا لم يكن هذا هو الكتاب الأخير في القائمة
                                                  if (index <
                                                      downloadedBooks.length -
                                                          1)
                                                    const Divider(
                                                      height: 1,
                                                      thickness: 0.5,
                                                    ),
                                                ],

                                                //  خيار التحميل إذا كان عدد الكتب أقل من 5
                                                if (downloadedBooks.length <
                                                    5) ...[
                                                  // خط فاصل عريض قليلاً ليفصل قسم الكتب عن زر الإجراء
                                                  const Divider(
                                                    height: 8,
                                                    thickness: 1,
                                                  ),
                                                  MenuItemButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pushNamed(
                                                        Routes.tafseerPage,
                                                      );
                                                    },
                                                    leadingIcon: Icon(
                                                      Icons
                                                          .cloud_download_outlined,
                                                      size: 18.w,
                                                      color: primaryColor,
                                                    ),
                                                    child: Text(
                                                      "تحميل تفسير",
                                                      style: TextStyle(
                                                        fontFamily: 'Cairo',
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ];
                                            },
                                          ),
                                          loading: () => [
                                            SizedBox(
                                              width: 150.w,
                                              child:
                                                  const LinearProgressIndicator(),
                                            ),
                                          ],
                                          error: (err, stack) => [
                                            Padding(
                                              padding: EdgeInsets.all(12.r),
                                              child: const Text(
                                                "خطأ في التحميل",
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // فاصل تحت الهيدر الثابت
                      const SliverToBoxAdapter(
                        child: Divider(thickness: .5, height: .5),
                      ),
                      // محتوى التفسير
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        sliver: SliverToBoxAdapter(
                          child: Consumer(
                            builder: (context, ref, child) {
                              final currentBook = ref.watch(
                                selectedBookProvider,
                              );
                              final finalBookId = currentBook.id;

                              final tafsserAsync = ref.watch(
                                ayahTafsserProvider((
                                  tafsserId: finalBookId,
                                  surahNumber: surahNumber,
                                  ayahNumber: verseNumber,
                                )),
                              );

                              return tafsserAsync.when(
                                data: (tafsser) {
                                  if (tafsser == null) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 40,
                                      ),
                                      child: Center(
                                        child: Text("لا يوجد بيانات"),
                                      ),
                                    );
                                  }

                                  return Padding(
                                    padding: EdgeInsets.only(top: 16.h),
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(16.r),
                                      decoration: BoxDecoration(
                                        color: surfaceContainer,
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                        border: Border.all(
                                          color: isDarkMode
                                              ? Colors.white10
                                              : Colors.black.withValues(
                                                  alpha: 0.05,
                                                ),
                                        ),
                                      ),
                                      child: SelectableText(
                                        tafsser.text,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          // height: 1.7,
                                          fontFamily: 'Naskh',
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                loading: () => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 40,
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                error: (err, stack) => const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40),
                                  child: Center(child: Text("حدث خطأ ما")),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(child: SizedBox(height: 30.h)),
                    ],
                  );
                },
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildHandle(bool isDarkMode) => Container(
  width: 45.w,
  height: 4.h,
  margin: EdgeInsets.symmetric(vertical: 12.h),
  decoration: BoxDecoration(
    color: isDarkMode ? Colors.white24 : Colors.black12,
    borderRadius: BorderRadius.circular(10),
  ),
);

ButtonStyle _buttonStyle(BuildContext context, bool isDarkMode) =>
    OutlinedButton.styleFrom(
      foregroundColor: isDarkMode ? Colors.white70 : const Color(0xFF5D4037),
      side: BorderSide(color: isDarkMode ? Colors.white24 : Colors.black12),
      backgroundColor: isDarkMode
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.white.withValues(alpha: 0.3),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
    );

/// Delegate بسيط لهيدر ثابت (بدون Collapse/Shrink)، يبقى بنفس الارتفاع دوماً.
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  _StickyHeaderDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
