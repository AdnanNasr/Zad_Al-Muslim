import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/core/themes/theme_notifier.dart';
import 'package:noor_quran/view_models/providers/theme_provider.dart';
import 'package:noor_quran/views/pages/home_page.dart';
import 'package:noor_quran/views/pages/settings_page.dart';

class CustomNavigationBar extends ConsumerStatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  ConsumerState<CustomNavigationBar> createState() =>
      _CustomNavigationBarState();
}

class _CustomNavigationBarState extends ConsumerState<CustomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [const HomePage(), const SettingsPage()];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isLight = themeMode == ThemeMode.light;
    final themeColor = Theme.of(context).colorScheme;
    final appColor = ref.watch(userThemeProvider);
    final blueWhaleColor = FlexScheme.blueWhale;
    final local = AppLocalizations.of(context)!;

    Color getInactiveColor() {
      if (appColor == blueWhaleColor) {
        return !isLight ? themeColor.scrim : themeColor.outline;
      }
      return themeColor.inversePrimary;
    }

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceIn,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              blurRadius: 10,
            ),
          ],
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: themeColor.onPrimary.withValues(alpha: .2),

            labelTextStyle: WidgetStateProperty.all(
              TextStyle(
                fontSize: context.mediaQueryWidth * 0.035,
                fontFamily: "Cairo",
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            labelPadding: const EdgeInsets.all(0),
            height: kBottomNavigationBarHeight + 7.h,
          ),
          child: NavigationBar(
            backgroundColor: Theme.of(context).primaryColor,
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
            destinations: [
              _buildDestination(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: local.home,
                inactiveColor: getInactiveColor(),
              ),
              _buildDestination(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: local.settings,
                inactiveColor: getInactiveColor(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  NavigationDestination _buildDestination({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color inactiveColor,
  }) {
    return NavigationDestination(
      icon: Icon(icon, color: inactiveColor),
      selectedIcon: Icon(
        activeIcon,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      label: label,
    );
  }
}
