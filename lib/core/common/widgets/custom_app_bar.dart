import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';
import 'package:zad_al_muslim/core/extensions/sizes_ext.dart';
import 'package:zad_al_muslim/features/settings/presentation/pages/settings_page.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool center;
  final IconData? icon;
  final bool themeMode; //! only for dev
  final bool isFullscreen;
  final Color? backgroundColor;
  final Widget? flexibleSpace;
  final bool shape;
  final PreferredSizeWidget? bottom;
  final void Function()? customVoid;
  final String? tooltip;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.center,
    this.icon,
    required this.themeMode,
    this.isFullscreen = false,
    this.backgroundColor,
    this.flexibleSpace,
    this.shape = false,
    this.bottom,
    this.customVoid,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeMode = ref.watch(themeProvider);
    return AppBar(
      primary: true,
      // toolbarHeight: kToolbarHeight,
      toolbarHeight: kBottomNavigationBarHeight,
      bottom: bottom,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontFamily: "Cairo",
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 12.w),
      centerTitle: center,
      leading: icon != null
          ? IconButton(
              tooltip: tooltip,
              icon: Icon(icon),
              color: Theme.of(context).colorScheme.onPrimary,
              onPressed: () {
                customVoid?.call();
                Navigator.of(context).pop();
              },
            )
          : null,
      // تأكدنا من أن لون الخلفية يغطي منطقة الـ SafeArea أيضاً عبر Scaffold إذا لزم الأمر،
      // ولكن هنا نكتفي بلون الـ AppBar
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      shape: shape
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(context.widthScreen * 0.08),
                bottomLeft: Radius.circular(context.widthScreen * 0.08),
              ),
            )
          : null,
      actions: [
        if (this.themeMode)
          Switch(
            value: themeMode == ThemeMode.dark,
            onChanged: (value) async {
              await ref.read(themeProvider.notifier).toggleTheme(themeMode);
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize {
    // نحتاج لإضافة ارتفاع الـ Status Bar إلى الارتفاع الإجمالي إذا لم يكن الـ Scaffold يتعامل معه
    double totalHeight = kToolbarHeight;
    if (bottom != null) {
      totalHeight += bottom!.preferredSize.height;
    }
    return Size.fromHeight(totalHeight);
  }
}
