import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/core/themes/theme_notifier.dart';

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

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle العلوي للسحب
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),

          // العنوان
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.app_color,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton.filledTonal(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      context.color.primary,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    size: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: context.color.onPrimary,
                  ),
                ),
              ],
            ),
          ),

          // شبكة الألوان (Grid)
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عنصرين في كل صف
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                mainAxisExtent: 100.h, // ارتفاع العنصر
              ),
              itemCount: colorSchemes.length,
              itemBuilder: (context, index) {
                final colorName = colorSchemes.keys.elementAt(index);
                final schemeValue = colorSchemes.values.elementAt(index);
                final isSelected = currentScheme == schemeValue;

                return _buildColorCard(colorName, schemeValue, isSelected);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCard(String name, FlexScheme scheme, bool isSelected) {
    final schemeColors = scheme.data;

    return GestureDetector(
      onTap: () => ref.read(userThemeProvider.notifier).setScheme(scheme),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Theme.of(context).primaryColor.withValues(alpha: .1)
                  : Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontFamily: "Cairo",
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    size: 18.sp,
                    color: Theme.of(context).primaryColor,
                  ),
              ],
            ),
            // لوحة الألوان الصغيرة
            Row(
              children: [
                _buildTinyCircle(schemeColors.light.primary),
                _buildTinyCircle(schemeColors.light.primaryContainer),
                _buildTinyCircle(schemeColors.light.secondary),
                _buildTinyCircle(schemeColors.light.tertiary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTinyCircle(Color color) {
    return Container(
      width: 24.w,
      height: 24.h,
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
    );
  }
}
