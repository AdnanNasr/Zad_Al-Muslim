import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/extensions/sizes_ext.dart';
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
  String _title = "";

  final fontFamiily = "Cairo";

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: widget.onTap,
      child: InkWell(
        key: _key,
        onTap: () async {
          final RenderBox renderBox =
              _key.currentContext!.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);
          final size = renderBox.size;

          String? selected = await showMenu<String>(
            context: context,
            elevation: 4,
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            position: RelativeRect.fromLTRB(
              position.dx,
              position.dy + size.height,
              position.dx + size.width,
              position.dy,
            ),

            items: widget.options
                .map(
                  (option) => PopupMenuItem<String>(
                    value: option,
                    child: Row(
                      children: [
                        Text(
                          option,
                          style: TextStyle(
                            fontSize: context.witdthScreen * 0.035,
                            color: widget.color ?? primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          );

          if (selected != null) {
            setState(() {
              _title = selected;
            });
            switch (widget.title) {
              case "الكتاب":
                ref.read(hadithProvider.notifier).setBook(_title);
                break;
              case "الرواي":
                ref.read(hadithProvider.notifier).setNarrator(_title);
                break;
              case "الموضوع":
                ref.read(hadithProvider.notifier).setTopic(_title);
                break;
              case "الدرجة":
                ref.read(hadithProvider.notifier).setGradeFromText(_title);
                break;
            }
          }

          if (ref.read(hadithProvider.notifier).isFilterEmpty()) {
            // _title = "";
            setState(() {});
          }
        },
        borderRadius: BorderRadius.circular(16.r),
        child: IntrinsicWidth(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: widget.color != null
                  ? widget.color!.withValues(alpha: .2)
                  : primary.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_title.isNotEmpty &&
                    ref.read(hadithProvider.notifier).isFilterEmpty())
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _title = "";
                      });
                      switch (widget.title) {
                        case "الكتاب":
                          ref.read(hadithProvider.notifier).setBook(null);
                          break;
                        case "الرواي":
                          ref.read(hadithProvider.notifier).setNarrator(null);
                          break;
                        case "الموضوع":
                          ref.read(hadithProvider.notifier).setTopic(null);
                          break;
                        case "الدرجة":
                          ref
                              .read(hadithProvider.notifier)
                              .setGradeFromText(null);
                          break;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(2.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      child: Icon(
                        Icons.close,
                        color: widget.color ?? primary,
                        size: context.witdthScreen * 0.05,
                      ),
                    ),
                  ),
                if (_title.isNotEmpty) SizedBox(width: 4.w),
                Text(
                  _title.isNotEmpty &&
                          ref.read(hadithProvider.notifier).isFilterEmpty()
                      ? _title
                      : widget.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: context.witdthScreen * 0.04,
                    color: widget.color ?? primary,
                    fontWeight: FontWeight.w600,
                    fontFamily: fontFamiily,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(widget.iconData, color: widget.color ?? primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
