import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/sizes_ext.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import '../../domain/entities/tafsser_entities.dart';
import '../providers/selected_book.dart';

class TafseerDialog extends ConsumerWidget {
  final TafsserBookEntity tafsserInfo;
  final bool isDownloaded;

  const TafseerDialog({
    super.key,
    required this.tafsserInfo,
    required this.isDownloaded,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBook = ref.watch(selectedBookProvider);
    final isSelected = selectedBook.id == tafsserInfo.id;

    return SimpleDialog(
      title: Center(
        child: Text(
          tafsserInfo.name,
          style: const TextStyle(
            fontFamily: "Cairo",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      contentPadding: EdgeInsets.all(16.r),
      children: [
        Text(
          tafsserInfo.description,
          style: TextStyle(
            fontSize: context.witdthScreen * 0.042,
            fontFamily: "Tajawal",
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        if (isDownloaded)
          ElevatedButton(
            onPressed: isSelected
                ? null
                : () {
                    ref
                        .read(selectedBookProvider.notifier)
                        .updateSelectedBook(tafsserInfo);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("تم تعيين ${tafsserInfo.name} كتفسير افتراضي"),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.color.primary,
              foregroundColor: context.color.onPrimary,
              disabledBackgroundColor: Colors.grey,
            ),
            child: Text(isSelected ? "محدد حالياً" : "تعيين كتفسير افتراضي"),
          )
        else
          Text(
            "يجب تحميل التفسير أولاً لاختياره",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.red,
              fontFamily: "Cairo",
            ),
          ),
      ],
    );
  }
}
