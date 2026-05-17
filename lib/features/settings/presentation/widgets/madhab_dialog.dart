import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/settings/presentation/providers/app_settings_provider.dart';

class MadhabDialog extends ConsumerWidget {
  const MadhabDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMadhab = ref.watch(appSettingsProvider).madhabIndex;

    final List<String> madhabs = ["تلقائي (شافعي، مالكي، حنبلي)", "حنفي"];
    final ThemeMode themeMode = ref.watch(themeProvider);
    final bool isDark = themeMode == ThemeMode.dark;

    return Dialog(
      // backgroundColor: context.color.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 10.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Hero(
                  tag: "mosque",
                  child: Icon(
                    Icons.mosque_rounded,
                    color: isDark
                        ? context.color.onSurface.withValues(alpha: .95)
                        : context.color.scrim.withValues(alpha: .8),
                    size: 25.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                const Text(
                  "المذهب (صلاة العصر)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Divider(color: context.color.onSurface.withValues(alpha: .1)),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(madhabs.length, (index) {
                  final bool isSelected = currentMadhab == index;
                  return ListTile(
                    title: Text(
                      madhabs[index],
                      style: TextStyle(
                        fontFamily: "Cairo",
                        fontSize: 14.sp,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      ref.read(appSettingsProvider.notifier).setMadhab(index);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "تم تحديث المذهب، يرجى إعادة تشغيل التطبيق لضمان دقة المواعيد.",
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "إلغاء",
                style: TextStyle(
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
