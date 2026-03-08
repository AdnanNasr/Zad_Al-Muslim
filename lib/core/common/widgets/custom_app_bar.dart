import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/features/settings/presentation/pages/settings_page.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool center;
  final IconData? icon;
  final bool profile;
  final bool isFullscreen;
  final Color? backgroundColor;
  final Widget? flexibleSpace;
  final bool shape;
  final TabBar? bottom;
  final void Function()? customVoid;
  const CustomAppBar({
    super.key,
    required this.title,
    required this.center,
    this.icon,
    required this.profile,
    this.isFullscreen = false,
    this.backgroundColor,
    this.flexibleSpace,
    this.shape = false,
    this.bottom,
    this.customVoid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      bottom: bottom,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
      title: Text(
        title,
        style: TextStyle(
          fontSize: context.witdthScreen * 0.06,
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontFamily: "Cairo",
        ),
      ),
      actionsPadding: const EdgeInsets.all(8),
      centerTitle: center,
      leading: icon != null
          ? IconButton(
              icon: Icon(icon),
              color: Theme.of(context).colorScheme.onPrimary,
              onPressed: () {
                customVoid?.call();
                Navigator.of(context).pop();
              },
            )
          : null,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      shape: shape
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(context.witdthScreen * 0.08),
                bottomLeft: Radius.circular(context.witdthScreen * 0.08),
              ),
            )
          : null,
      actions: [
        if (profile)
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              color: Theme.of(context).colorScheme.onPrimary,
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const SettingsPage();
                    },
                  ),
                );
              },
              icon: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (bottom != null) {
      height += bottom!.preferredSize.height; // يزيد ارتفاع AppBar حسب TabBar
    }
    return Size.fromHeight(height);
  }
}
