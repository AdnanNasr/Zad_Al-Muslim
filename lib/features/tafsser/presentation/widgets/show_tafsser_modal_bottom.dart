import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/features/quran/data/models/quran_models.dart';
import 'package:noor_quran/features/tafsser/domain/entities/tafsser_entities.dart';
import 'package:noor_quran/features/tafsser/presentation/providers/tafsser_book_provider.dart';
import 'package:noor_quran/features/tafsser/presentation/providers/tafsser_provider.dart';

Future<dynamic> showTafsserModalBottom(
  BuildContext context,
  WidgetRef ref,
  Ayah ayah,
  String bookId,
  AyahTafsserEntity initialTafsser,
) async {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          final selectedBook = ref.watch(selectedTafsserBookProvider);
          final booksAsync = ref.watch(tafsserBooksProvider);

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
                          key: ValueKey(booksAsync.value?.length ?? 0),
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
                                selectedBook?.name ?? "اختار التفسير",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              icon: const Icon(Icons.arrow_drop_down),
                              style: _buttonStyle(context),
                            );
                          },
                          menuChildren: booksAsync.when(
                            data: (books) => books
                                .where((book) => book.isDownloaded)
                                .map((book) {
                              return MenuItemButton(
                                onPressed: () {
                                  ref.read(selectedTafsserBookProvider.notifier).state = book;
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                                  child: Text(book.name),
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
                                onPressed: () => ref.invalidate(tafsserBooksProvider),
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
                          final currentBook = ref.watch(selectedTafsserBookProvider);
                          
                          // If no book selected, use the passed bookId
                          final finalBookId = currentBook?.id ?? bookId;

                          final tafsserAsync = ref.watch(ayahTafsserProvider((
                            tafsserId: finalBookId,
                            surahNumber: ayah.surahNumber,
                            ayahNumber: ayah.ayahNumber,
                          )));

                          return tafsserAsync.when(
                            data: (tafsser) {
                              if (tafsser == null) {
                                return const Center(child: Text("تعذر تحميل التفسير لهذا الكتاب"));
                              }
                              return ListView(
                                controller: scrollController,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(8.r),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(15.r),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Text(
                                      tafsser.text,
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
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (err, stack) => const Center(child: Text("خطأ في تحميل التفسير")),
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
