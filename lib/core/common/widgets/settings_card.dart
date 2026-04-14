import "package:dartz/dartz.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:noor_quran/core/extensions/sizes_ext.dart";
import "package:noor_quran/core/common/providers/theme_provider.dart";

class SettingCards extends ConsumerWidget {
  final Either<Widget, IconData> icon;
  final String text;
  final String? subText;
  final void Function()? onTap;
  final IconData? trallingIcon;
  final bool? toggle;
  final BorderRadius? borderRadius;
  final void Function(bool)? onChanged;
  final Widget? widget;
  final Color? forgroundColor;
  final bool? hero;
  final String? heroId;
  final bool? switchValue;
  const SettingCards({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.trallingIcon,
    this.toggle,
    this.borderRadius,
    this.onChanged,
    this.widget,
    this.forgroundColor,
    this.hero,
    this.heroId,
    this.switchValue,
    this.subText,
  });

  // checkTheme
  Color checkTheme({
    required themeMode,
    required lightColor,
    required darkColor,
  }) {
    return themeMode == ThemeMode.light ? lightColor : darkColor;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    Color? bgColor;
    if (forgroundColor == Colors.blue) {
      bgColor = Colors.blue.shade100;
    } else if (forgroundColor == Colors.green) {
      bgColor = Colors.green.shade100;
    } else if (forgroundColor == Colors.purple) {
      bgColor = Colors.purple.shade100;
    } else if (forgroundColor == Colors.indigo) {
      bgColor = Colors.indigo.shade100;
    } else if (forgroundColor == Colors.yellow.shade800) {
      bgColor = Colors.yellow.shade100;
    } else {
      bgColor = forgroundColor?.withValues(alpha: 0.15);
    }
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius ?? BorderRadius.circular(0),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.only(right: context.witdthScreen * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color:
                      bgColor ??
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: .15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: icon.fold(
                    (widget) {
                      return widget;
                    },
                    (iconData) {
                      return Icon(
                        iconData,
                        size: context.witdthScreen * 0.08,
                        color:
                            forgroundColor ??
                            Theme.of(context).colorScheme.primary,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (subText != null)
                Expanded(
                  child: Column(
                    spacing: 4.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(fontSize: 18.sp),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        subText!,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              if (subText == null)
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 18.sp),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              if (toggle != null && toggle!)
                Switch(value: switchValue ?? false, onChanged: onChanged)
              else if (widget != null)
                widget!
              else if (trallingIcon != null)
                Icon(
                  trallingIcon,
                  color: checkTheme(
                    themeMode: themeMode,
                    lightColor: Colors.grey.shade400,
                    darkColor: Colors.grey.shade700,
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios,
                  color: checkTheme(
                    themeMode: themeMode,
                    lightColor: Colors.grey.shade400,
                    darkColor: Colors.grey.shade700,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
