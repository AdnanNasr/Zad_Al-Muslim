import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/providers/tafsser_book_provider.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/providers/tafsser_provider.dart';

Future<dynamic> showTafsserModalBottom(
  BuildContext context,
  WidgetRef ref,
  int surahNumber,
  int verseNumber,
  String bookId,
) async {
  // تحديد الألوان بناءً على حالة الثيم
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final Color bgColor = isDarkMode
      ? const Color(0xFF1E1E1E)
      : const Color(0xFFF5E6D3);
  final Color surfaceContainer = isDarkMode
      ? const Color(0xFF2C2C2C)
      : Colors.white.withValues(alpha: 0.6);
  final Color textColor = isDarkMode
      ? const Color(0xFFE0E0E0)
      : const Color(0xFF3E2723);
  final Color primaryColor = context.color.primary;

  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // لجعل الحواف العلوية تعمل بشكل صحيح
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          final selectedBook = ref.watch(selectedTafsserBookProvider);
          final booksAsync = ref.watch(tafsserBooksProvider);

          return Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.5,
              maxChildSize: 0.9,
              minChildSize: 0.4,
              builder: (context, scrollController) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      _buildHandle(isDarkMode),

                      // الهيدر: العنوان واختيار الكتاب
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              key: ValueKey(booksAsync.value?.length ?? 0),
                              builder: (context, controller, child) {
                                return OutlinedButton.icon(
                                  onPressed: () => controller.isOpen
                                      ? controller.close()
                                      : controller.open(),
                                  label: Text(
                                    selectedBook?.name ?? "اختار التفسير",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 20,
                                  ),
                                  style: _buttonStyle(context, isDarkMode),
                                );
                              },
                              menuChildren: booksAsync.when(
                                data: (books) => books
                                    .where((book) => book.isDownloaded)
                                    .map(
                                      (book) => MenuItemButton(
                                        onPressed: () =>
                                            ref
                                                    .read(
                                                      selectedTafsserBookProvider
                                                          .notifier,
                                                    )
                                                    .state =
                                                book,
                                        child: Text(
                                          book.name,
                                          style: const TextStyle(
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                loading: () => [
                                  const LinearProgressIndicator(),
                                ],
                                error: (err, stack) => [
                                  const Text("خطأ في التحميل"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(thickness: 0.5),

                      // محتوى التفسير
                      Expanded(
                        child: Consumer(
                          builder: (context, ref, child) {
                            final currentBook = ref.watch(
                              selectedTafsserBookProvider,
                            );
                            final finalBookId = currentBook?.id ?? bookId;

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
                                  return const Center(
                                    child: Text("لا يوجد بيانات"),
                                  );
                                }

                                return ListView(
                                  controller: scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    Container(
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
                                    SizedBox(height: 30.h),
                                  ],
                                );
                              },
                              loading: () => Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              ),
                              error: (err, stack) =>
                                  const Center(child: Text("حدث خطأ ما")),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
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
