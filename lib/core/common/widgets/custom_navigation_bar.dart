import 'dart:ui';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/l10n/app_localizations.dart';
import 'package:zad_al_muslim/core/themes/theme_notifier.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';
import 'package:zad_al_muslim/core/common/pages/home/home_page.dart';
import 'package:zad_al_muslim/features/settings/presentation/pages/settings_page.dart';

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
    const blueWhaleColor = FlexScheme.blueWhale;
    final local = AppLocalizations.of(context)!;

    Color getInactiveColor() {
      if (appColor == blueWhaleColor) {
        return !isLight ? themeColor.scrim : themeColor.outline;
      }
      return themeColor.inversePrimary;
    }

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 25.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: (isLight ? themeColor.primary : themeColor.surface)
                    .withValues(alpha: isLight ? 0.08 : 0.9),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: (themeColor.outline).withValues(alpha: 0.2),
                  width: 1.2,
                ),
              ),
              child: NavigationBarTheme(
                data: NavigationBarThemeData(
                  indicatorColor: themeColor.primary.withValues(alpha: 0.15),
                  labelTextStyle: WidgetStateProperty.resolveWith((states) {
                    final isSelected = states.contains(WidgetState.selected);
                    return TextStyle(
                      fontSize: 12.sp,
                      fontFamily: "Cairo",
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? themeColor.primary
                          : getInactiveColor(),
                    );
                  }),
                  labelPadding: EdgeInsets.zero,
                  height: 65.h,
                ),
                child: NavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() => _currentIndex = index);
                  },
                  destinations: [
                    _buildDestination(
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                      label: local.home,
                      inactiveColor: getInactiveColor(),
                    ),
                    _buildDestination(
                      icon: Icons.settings_outlined,
                      activeIcon: Icons.settings_rounded,
                      label: local.settings,
                      inactiveColor: getInactiveColor(),
                    ),
                  ],
                ),
              ),
            ),
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
      icon: Icon(icon, color: inactiveColor, size: 22.sp),
      selectedIcon: Icon(
        activeIcon,
        color: Theme.of(context).colorScheme.primary,
        size: 24.sp,
      ),
      label: label,
    );
  }

  // Helper to get labels for indexing
  List<String> _buildDestinationList() {
    final local = AppLocalizations.of(context)!;
    return [local.home, local.settings];
  }
}
