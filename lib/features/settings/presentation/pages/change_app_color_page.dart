import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/l10n/app_localizations.dart';
import 'package:zad_al_muslim/core/themes/app_theme.dart';
import 'package:zad_al_muslim/core/themes/theme_notifier.dart';

class ChangeAppColorPage extends ConsumerStatefulWidget {
  const ChangeAppColorPage({super.key});

  @override
  ConsumerState<ChangeAppColorPage> createState() => _ChangeAppColorPageState();
}

class _ChangeAppColorPageState extends ConsumerState<ChangeAppColorPage> {
  static const Map<String, Color> appColors = {
    'فيروزي (الافتراضي)': AppTheme.defaultPrimary,
    'أخضر زيتوني': Color(0xFF4F6F52),
    'أزرق ليلي': Color(0xFF345995),
    'بنفسجي هادئ': Color(0xFF695783),
    'عنابي': Color(0xFF8A3F4D),
    'بني رملي': Color(0xFF8A6543),
  };

  @override
  Widget build(BuildContext context) {
    final currentAppColor = ref.watch(userThemeProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    size: 18.sp,
                    fontWeight: FontWeight.bold,
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
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                mainAxisExtent: 80.h,
              ),
              itemCount: appColors.length,
              itemBuilder: (context, index) {
                final entry = appColors.entries.elementAt(index);
                final color = entry.value;
                final isSelected = currentAppColor == color;

                return _buildColorCard(color, isSelected, entry.key);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCard(Color color, bool isSelected, String colorName) {
    return GestureDetector(
      onTap: () => ref.read(userThemeProvider.notifier).setScheme(color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.08)
              : context.color.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? color : context.color.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                colorName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: context.color.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: isSelected
                  ? Icon(
                      Icons.check_circle_rounded,
                      key: ValueKey(color),
                      size: 22.sp,
                      color: color,
                    )
                  : SizedBox(width: 22.w),
            ),
          ],
        ),
      ),
    );
  }
}
