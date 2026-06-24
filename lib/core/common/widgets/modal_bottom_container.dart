import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModalBottomContainer extends StatelessWidget {
  final List<Widget> cards;
  final Color? backgroundColor;
  final Color? dividerColor;
  const ModalBottomContainer({
    super.key,
    required this.cards,
    this.backgroundColor,
    this.dividerColor,
  });

  Color checkTheme({
    required ThemeMode themeMode,
    required Color lightColor,
    required Color darkColor,
  }) {
    return themeMode == ThemeMode.light ? lightColor : darkColor;
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? primary.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...cards.asMap().entries.map((entries) {
                final index = entries.key;
                final card = entries.value;
                return Column(
                  children: [
                    card,
                    if (index != cards.length - 1) ...[
                      Divider(
                        color: dividerColor ?? primary.withValues(alpha: 0.18),
                        thickness: .8,
                        indent: 5,
                        endIndent: 0.1,
                        height: 1,
                      ),
                    ],
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
