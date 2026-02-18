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

  // The old implementation registered a listener in `initState`.  Riverpod
  // now asserts that `ref.listen` may only be invoked during a build of a
  // `ConsumerWidget`.  To keep the container's local `_title` in sync with the
  // provider we instead compute the current value on each build and schedule a
  // post-frame callback if an update is needed.

  final fontFamiily = "Cairo";

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    // compute the value that should currently be displayed according to the
    // provider state.  if it differs from `_title` we push a post-frame
    // callback to update it after this build completes.
    final notifier = ref.watch(hadithProvider.notifier);
    String? current;
    switch (widget.title) {
      case "الكتاب":
        current = notifier.currentBook;
        break;
      case "الرواي":
        current = notifier.currentNarrator;
        break;
      case "الموضوع":
        current = notifier.currentTopic;
        break;
      case "الدرجة":
        current = notifier.currentGradeText;
        break;
    }

    if ((current ?? "") != _title) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _title = current ?? "";
        });
      });
    }

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
                if (_title.isNotEmpty)
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
                  _title.isNotEmpty ? _title : widget.title,
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
