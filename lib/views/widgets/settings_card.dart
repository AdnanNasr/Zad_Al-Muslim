import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:noor_quran/core/extensions/sizes_ext.dart";
import "package:noor_quran/view_models/providers/theme_provider.dart";

class SettingCards extends ConsumerWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;
  final IconData? trallingIcon;
  final bool? toggle;
  final BorderRadius? borderRadius;
  final void Function(bool)? onChanged;
  final Widget? widget;
  final Color? forgroundColor;
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
          height: context.heightScreen * 0.06,
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
                  child: Icon(
                    icon,
                    size: context.witdthScreen * 0.08,
                    color:
                        forgroundColor ?? Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(fontSize: context.witdthScreen * 0.05),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (toggle != null && toggle!)
                Switch(value: themeMode == ThemeMode.dark, onChanged: onChanged)
              else if (widget != null)
                widget!
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
