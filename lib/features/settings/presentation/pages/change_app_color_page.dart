import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';

import 'package:noor_quran/core/themes/theme_notifier.dart';

class CustomSchemeColors {
  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;

  const CustomSchemeColors({
    required this.color1,
    required this.color2,
    required this.color3,
    required this.color4,
  });
}

class ChangeAppColorPage extends ConsumerStatefulWidget {
  const ChangeAppColorPage({super.key});

  @override
  ConsumerState<ChangeAppColorPage> createState() => _ChangeAppColorPageState();
}

class _ChangeAppColorPageState extends ConsumerState<ChangeAppColorPage> {
  Map<String, FlexScheme> get colorSchemes => {
    AppLocalizations.of(context)!.brandBlue: FlexScheme.brandBlue,
    AppLocalizations.of(context)!.blueWhale: FlexScheme.blueWhale,
    AppLocalizations.of(context)!.sakura: FlexScheme.sakura,
    AppLocalizations.of(context)!.gold: FlexScheme.gold,
    AppLocalizations.of(context)!.vesuviusBurn: FlexScheme.vesuviusBurn,
    AppLocalizations.of(context)!.barossa: FlexScheme.barossa,
    AppLocalizations.of(context)!.shark: FlexScheme.shark,        
    AppLocalizations.of(context)!.money: FlexScheme.money,
  };

  @override
  Widget build(BuildContext context) {
    final currentScheme = ref.watch(userThemeProvider);

    final screenWidth = context.witdthScreen;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
              Text(
                AppLocalizations.of(context)!.app_color,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.color_lens, size: context.witdthScreen * 0.08),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: colorSchemes.length,
              itemBuilder: (context, index) {
                final colorName = colorSchemes.keys.elementAt(index);
                final schemeValue = colorSchemes.values.elementAt(index);

                return Card(
                  // margin: EdgeInsets.symmetric(
                  //   vertical: context.heightScreen * 0.01,
                  //   horizontal: context.witdthScreen * 0.02,
                  // ),
                  child: _buildListTile(
                    colorName,
                    schemeValue,
                    currentScheme,
                    ref,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  CustomSchemeColors _getCustomColors(String colorName) {
    if (colorName == AppLocalizations.of(context)!.brandBlue) {
      return const CustomSchemeColors(
        color1: Color(0xFF8B9DC3),
        color2: Color(0xFF3B5998),
        color3: Color(0xFFA0D1F5),
        color4: Color(0xFF004B75),
      );
    } else if (colorName == AppLocalizations.of(context)!.blueWhale) {
      return const CustomSchemeColors(
        color1: Color(0xFF57859D),
        color2: Color(0xFF2A9D8F),
        color3: Color(0xFFFF6E48),
        color4: Color(0xFFA3290F),
      );
    } else if (colorName == AppLocalizations.of(context)!.sakura) {
      return const CustomSchemeColors(
        color1: Color(0xFFEEC4D8),
        color2: Color(0xFFCE5B78),
        color3: Color(0xFFF5D6C6),
        color4: Color(0xFFEBA689),
      );
    } else if (colorName == AppLocalizations.of(context)!.gold) {
      return const CustomSchemeColors(
        color1: Color(0xFFEDA85E),
        color2: Color(0xFFB86914),
        color3: Color(0xFFD28F60),
        color4: Color(0xFFB5642C),
      );
    } else if (colorName == AppLocalizations.of(context)!.vesuviusBurn) {
      return const CustomSchemeColors(
        color1: Color(0xFFD17D53),
        color2: Color(0xFF874E32),
        color3: Color(0xFF5B8A8E),
        color4: Color(0xFF0D494D),
      );
    } else if (colorName == AppLocalizations.of(context)!.barossa) {
      return const CustomSchemeColors(
        color1: Color(0xFF94667E),
        color2: Color(0xFF4E0029),
        color3: Color(0xFF6B9882),
        color4: Color(0xFF21614C),
      );
    } else if (colorName == AppLocalizations.of(context)!.shark) {
      return const CustomSchemeColors(
        color1: Color(0xFF777A7E),
        color2: Color(0xFF313C42),
        color3: Color(0xFFFCB075),
        color4: Color(0xFFD97B18),
      );
    } else if (colorName == AppLocalizations.of(context)!.money) {
      return const CustomSchemeColors(
        color1: Color(0xFF7AB893),
        color2: Color(0xFF224430),
        color3: Color(0xFFD5D6A8),
        color4: Color(0xFF515402),
      );
    } else {
      return const CustomSchemeColors(
        color1: Colors.grey,
        color2: Colors.blueGrey,
        color3: Colors.white,
        color4: Colors.lightBlue,
      );
    }
  }

  Widget _buildListTile(
    String colorName,
    FlexScheme schemeValue,
    FlexScheme currentScheme,
    WidgetRef ref,
  ) {
    final customColors = _getCustomColors(colorName);

    final schemePrimaryColor = schemeValue.data.light;

    final screenWidth = context.witdthScreen;

    return SizedBox(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),

        onTap: () {
          ref.read(userThemeProvider.notifier).setScheme(schemeValue);
        },

        title: Text(
          colorName,
          style: TextStyle(
            fontSize: screenWidth * 0.055.sp,
            fontWeight: FontWeight.w500,
          ),
        ),

        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildColorCircle(customColors.color4),
            _buildColorCircle(customColors.color3),
            _buildColorCircle(customColors.color2),
            _buildColorCircle(customColors.color1),
          ],
        ),

        trailing: currentScheme == schemeValue
            ? Icon(Icons.check_circle, color: schemePrimaryColor.primary)
            : null,
      ),
    );
  }

  Widget _buildColorCircle(Color color) {
    return Container(
      width: 20,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
        color: color,
        border: Border.all(color: Colors.black12, width: 1),
      ),
    );
  }
}
