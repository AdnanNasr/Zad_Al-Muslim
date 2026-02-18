import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/extensions/color_ext.dart';
import 'package:noor_quran/view_models/models/db/islamic/quran_models.dart';
import 'package:noor_quran/view_models/models/db/islamic/tafsser/ayah.dart';
import 'package:noor_quran/view_models/providers/avalible_tafsser_books.dart';
import 'package:noor_quran/view_models/providers/tafsser_book_provider.dart';
import 'package:noor_quran/view_models/providers/tafsser_provider.dart';

Future<dynamic> showTafsserModalBottom(
  BuildContext context,
  WidgetRef ref,
  Ayah ayah,
  AyahTafsser tafsserAyah,
) async {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          final tafsserBook = ref.watch(tafsserBookProvider);
          final availableBooksAsync = ref.watch(availableTafsserBooksProvider);

          return Container(
            decoration: BoxDecoration(
              color: context.color.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.4,
              maxChildSize: 0.9,
              minChildSize: 0.3,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    _buildHandle(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "تفسير الآية ${ayah.ayahNumber}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),

                        MenuAnchor(
                          key: ValueKey(availableBooksAsync.value?.length ?? 0),
                          builder: (context, controller, child) {
                            return OutlinedButton.icon(
                              onPressed: () {
                                if (controller.isOpen) {
                                  controller.close();
                                } else {
                                  controller.open();
                                }
                              },
                              label: Text(
                                tafsserBook.value?.name ?? "اختار التفسير",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              icon: Icon(Icons.arrow_drop_down),
                              style: _buttonStyle(context),
                            );
                          },
                          menuChildren: availableBooksAsync.when(
                            data: (books) => books.map((edition) {
                              return MenuItemButton(
                                onPressed: () async {
                                  ref
                                      .read(tafsserBookProvider.notifier)
                                      .setTafsserBook(
                                        tafseerName: edition!.name!,
                                      );
                                  ref.invalidate(tafsserProvider);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  child: Text(edition?.name ?? ""),
                                ),
                              );
                            }).toList(),
                            loading: () => [
                              const SizedBox(
                                width: 100,
                                child: LinearProgressIndicator(),
                              ),
                            ],
                            error: (err, stack) => [
                              MenuItemButton(
                                onPressed: () => ref.invalidate(
                                  availableTafsserBooksProvider,
                                ),
                                child: const Text("خطأ، اضغط للتحديث"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(),

                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          // 1. مراقبة الكتاب المختار حالياً
                          final currentBook = ref.watch(tafsserBookProvider);

                          // 2. استخدام FutureBuilder لجلب نص التفسير للكتاب الجديد
                          return FutureBuilder<AyahTafsser?>(
                            // نستدعي دالة البحث التي أصلحناها سابقاً
                            future: ref
                                .read(tafsserProvider.notifier)
                                .getTafsserByAyahNumber(
                                  surahNumber: ayah.surahNumber,
                                  ayahNumber: ayah.ayahNumber,
                                  edition: currentBook.value!,
                                ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasError || snapshot.data == null) {
                                return const Center(
                                  child: Text("تعذر تحميل التفسير لهذا الكتاب"),
                                );
                              }

                              final newTafsserText = snapshot.data!.text;

                              return ListView(
                                controller: scrollController,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(8.r),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(15.r),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Text(
                                      newTafsserText, // النص الجديد القادم من قاعدة البيانات
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 21.sp,
                                        height: 1.6,
                                        fontFamily: 'Naskh',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    },
  );
}

Widget _buildHandle() => Container(
  width: 40,
  height: 5,
  margin: const EdgeInsets.only(bottom: 20),
  decoration: BoxDecoration(
    color: Colors.grey[300],
    borderRadius: BorderRadius.circular(10),
  ),
);

ButtonStyle _buttonStyle(BuildContext context) => OutlinedButton.styleFrom(
  foregroundColor: context.color.onSurface,
  side: BorderSide(color: context.color.outline.withValues(alpha: .5)),
  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
);
