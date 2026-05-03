import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/settings/presentation/providers/app_settings_provider.dart';

class CalculationMethodDialog extends ConsumerWidget {
  const CalculationMethodDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMethod = ref.watch(appSettingsProvider).calculationMethodIndex;

    final List<String> methods = [
      "تلقائي (بناءً على الموقع)",
      "رابطة العالم الإسلامي",
      "جامعة أم القرى (مكة)",
      "الهيئة المصرية العامة للمساحة",
      "جامعة العلوم الإسلامية (كراتشي)",
      "رئاسة الشؤون الدينية (تركيا)",
      "دائرة الشؤون الإسلامية (دبي)",
      "لجنة رؤية الهلال (Moon Sighting)",
      "الجمعية الإسلامية لأمريكا الشمالية (ISNA)",
      "الكويت",
      "قطر",
      "سنغافورة",
      "معهد الجيوفيزياء (جامعة طهران)",
    ];

    return Dialog(
      // backgroundColor: context.color.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 10.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Hero(
                  tag: "timer",
                  child: Icon(
                    Icons.timer,
                    color: context.color.primary,
                    size: 25.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  "طريقة حساب المواقيت",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Divider(color: context.color.onSurface.withValues(alpha: .1)),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: calculatNames(methods, currentMethod, context, ref),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Divider(color: context.color.onSurface.withValues(alpha: .1)),
            TextButton(
              style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "إلغاء",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Cairo",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> calculatNames(
    List<String> methods,
    int currentMethod,
    BuildContext context,
    WidgetRef ref,
  ) {
    return List.generate(methods.length, (index) {
      final bool isSelected = currentMethod == index;
      return ListTile(
        title: Text(
          methods[index],
          style: TextStyle(
            fontFamily: "Cairo",
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Theme.of(context).colorScheme.primary : null,
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: () {
          ref.read(appSettingsProvider.notifier).setCalculationMethod(index);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "تم تحديث طريقة الحساب، يرجى إعادة تشغيل التطبيق لضمان دقة المواعيد.",
              ),
            ),
          );
        },
      );
    });
  }
}
