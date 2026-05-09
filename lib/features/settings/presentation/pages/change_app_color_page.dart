import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/l10n/app_localizations.dart';
import 'package:zad_al_muslim/core/themes/theme_notifier.dart';

class ChangeAppColorPage extends ConsumerStatefulWidget {
  const ChangeAppColorPage({super.key});

  @override
  ConsumerState<ChangeAppColorPage> createState() => _ChangeAppColorPageState();
}

class _ChangeAppColorPageState extends ConsumerState<ChangeAppColorPage> {
  // قائمة الألوان المقترحة للتطبيق
  final Map<String, Color> appColors = {
    "الافتراضي": const Color.fromARGB(
      255,
      19,
      116,
      129,
    ), // ازرق هادئ: اللون الافتراضي
    "نيلي": Colors.teal, // ازرق هادئ
    "ازرق": Colors.blue.shade700, // أزرق براند
    "أخضر": Colors.green.shade700, // أخضر إسلامي
    "أحمر": Colors.red, // أحمر
    "بنفسجي": Colors.purple, // بنفسجي
    "وردي": Colors.pink, // وردي
    "برتقالي": Colors.orange.shade700, // برتقالي
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
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                mainAxisExtent: 80.h,
              ),
              itemCount: appColors.length,
              itemBuilder: (context, index) {
                final color = appColors.values.toList()[index];
                final isSelected = currentAppColor == color;

                return _buildColorCard(
                  color,
                  isSelected,
                  appColors.keys.toList()[index],
                );
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
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withValues(alpha: .15)
                  : Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              colorName,
              style: TextStyle(
                fontSize: 18.sp,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              width: 35.w,
              height: 35.h,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, size: 22.sp, color: color),
          ],
        ),
      ),
    );
  }
}
