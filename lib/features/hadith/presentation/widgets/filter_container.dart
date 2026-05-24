import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/constants/enums/my_enums.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/extensions/sizes_ext.dart';
import 'package:zad_al_muslim/features/hadith/presentation/providers/hadith_provider.dart';

class BookFilterContainer extends ConsumerStatefulWidget {
  final String title;
  final IconData iconData;
  final Color? color;

  const BookFilterContainer({
    super.key,
    required this.title,
    required this.iconData,
    this.color,
  });

  @override
  ConsumerState<BookFilterContainer> createState() =>
      _BookFilterContainerState();
}

class _BookFilterContainerState extends ConsumerState<BookFilterContainer> {
  final GlobalKey _key = GlobalKey();
  final String fontFamily = "Cairo";

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    ref.watch(hadithProvider); // الاستماع لتغيرات الأحاديث لإعادة البناء
    final notifier = ref.read(hadithProvider.notifier);
    final int? currentBookNumber = notifier.currentBookNumber;
    SahihBukhariBook? activeBook;

    if (currentBookNumber != null) {
      activeBook = SahihBukhariBook.fromId(currentBookNumber);
    }

    final String displayTitle = activeBook?.arabicName ?? widget.title;
    final bool isFiltered = activeBook != null;

    return InkWell(
      key: _key,
      onTap: () async {
        final RenderBox renderBox =
            _key.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;

        SahihBukhariBook? selected = await showMenu<SahihBukhariBook>(
          context: context,
          elevation: 4,
          constraints: BoxConstraints(maxHeight: context.mediaQueryHeight / 2),
          color: Theme.of(context).cardColor,
          menuPadding: EdgeInsets.all(8.dg),
          // positionBuilder: (context, constraints) {

          // },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(color: context.color.primary),
          ),
          position: RelativeRect.fromLTRB(
            position.dx,
            position.dy + size.height + 5.h,
            position.dx + size.width + 5.w,
            position.dy,
          ),
          items: SahihBukhariBook.values
              .map(
                (book) => PopupMenuItem<SahihBukhariBook>(
                  value: book,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.arabicName,
                        style: TextStyle(
                          fontSize: context.witdthScreen * 0.035,
                          color: context.color.onSurface,
                          fontFamily: fontFamily,
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              )
              .toList(),
        );

        if (selected != null) {
          ref.read(hadithProvider.notifier).setBook(selected.id);
        }
      },
      borderRadius: BorderRadius.circular(16.r),
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: isFiltered
                ? (widget.color ?? primary).withValues(alpha: .3)
                : (widget.color ?? primary).withValues(alpha: .2),
            borderRadius: BorderRadius.circular(16.r),
            border: isFiltered
                ? Border.all(color: widget.color ?? primary, width: 1)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isFiltered)
                GestureDetector(
                  onTap: () => ref.read(hadithProvider.notifier).setBook(null),
                  child: Container(
                    margin: EdgeInsetsDirectional.only(end: 10.w),
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (widget.color ?? primary).withValues(alpha: .2),
                    ),
                    child: Icon(
                      Icons.close,
                      color: widget.color ?? context.color.onSurface,
                      size: 15.sp,
                    ),
                  ),
                ),
              Text(
                displayTitle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: isFiltered ? 12.sp : 15.sp,
                  color: context.color.onSurface,
                  fontWeight: isFiltered ? FontWeight.bold : FontWeight.w600,
                  fontFamily: fontFamily,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                widget.iconData,
                color: context.color.onSurface,
                size: 18.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
