import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/view_models/providers/hadith_provider.dart';

class FilterContainer extends ConsumerStatefulWidget {
  final String title;
  final IconData iconData;
  final Color? color;
  final List<dynamic> options;
  final void Function()? onTap;

  const FilterContainer({
    super.key,
    required this.title,
    required this.iconData,
    this.color,
    required this.options,
    this.onTap,
  });

  @override
  ConsumerState<FilterContainer> createState() => _FilterContainerState();
}

class _FilterContainerState extends ConsumerState<FilterContainer> {
  final GlobalKey _key = GlobalKey();
  final String fontFamily = "Cairo";

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    // 1. نراقب الـ Notifier للحصول على القيم الحالية للفلاتر
    final notifier = ref.watch(hadithProvider.notifier);
    
    // 2. تحديد النص المعروض بناءً على نوع الفلتر من الـ Notifier مباشرة
    String? activeFilterValue;
    switch (widget.title) {
      case "الكتاب":
        activeFilterValue = notifier.currentBook;
        break;
      case "الرواي":
        activeFilterValue = notifier.currentNarrator;
        break;
      case "الموضوع":
        activeFilterValue = notifier.currentTopic;
        break;
      case "الدرجة":
        activeFilterValue = notifier.currentGradeText;
        break;
    }

    // النص الذي سيظهر: إما قيمة الفلتر النشط أو عنوان الحاوية الأصلي
    final String displayTitle = (activeFilterValue != null && activeFilterValue.isNotEmpty) 
        ? activeFilterValue 
        : widget.title;

    final bool isFiltered = activeFilterValue != null && activeFilterValue.isNotEmpty;

    return InkWell(
      key: _key,
      onTap: () async {
        final RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;

        String? selected = await showMenu<String>(
          context: context,
          elevation: 4,
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          position: RelativeRect.fromLTRB(
            position.dx,
            position.dy + size.height,
            position.dx + size.width,
            position.dy,
          ),
          items: widget.options.map((option) => PopupMenuItem<String>(
            value: option.toString(),
            child: Text(
              option.toString(),
              style: TextStyle(
                fontSize: context.witdthScreen * 0.035,
                color: widget.color ?? primary,
                fontFamily: fontFamily,
              ),
            ),
          )).toList(),
        );

        if (selected != null) {
          _updateFilter(selected);
        }
      },
      borderRadius: BorderRadius.circular(16.r),
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          decoration: BoxDecoration(
            // تغيير لون الخلفية إذا كان الفلتر نشطاً لتمييزه
            color: isFiltered 
                ? (widget.color ?? primary).withValues(alpha: .3)
                : (widget.color ?? primary).withValues(alpha: .1),
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
                  onTap: () => _updateFilter(null),
                  child: Container(
                    margin: EdgeInsetsDirectional.only(end: 10.w),
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (widget.color ?? primary).withValues(alpha: .2),
                    ),
                    child: Icon(
                      Icons.close,
                      color: widget.color ?? primary,
                      size: context.witdthScreen * 0.045,
                    ),
                  ),
                ),
              Text(
                displayTitle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: context.witdthScreen * 0.038,
                  color: widget.color ?? primary,
                  fontWeight: isFiltered ? FontWeight.bold : FontWeight.w600,
                  fontFamily: fontFamily,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(widget.iconData, 
                   color: widget.color ?? primary, 
                   size: context.witdthScreen * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  // دالة موحدة لتحديث الفلتر بناءً على العنوان
  void _updateFilter(String? value) {
    final notifier = ref.read(hadithProvider.notifier);
    switch (widget.title) {
      case "الكتاب":
        notifier.setBook(value);
        break;
      case "الرواي":
        notifier.setNarrator(value);
        break;
      case "الموضوع":
        notifier.setTopic(value);
        break;
      case "الدرجة":
        notifier.setGradeFromText(value);
        break;
    }
  }
}