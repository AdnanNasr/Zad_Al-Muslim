import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/features/settings/presentation/providers/app_settings_provider.dart';

class MadhabDialog extends ConsumerWidget {
  const MadhabDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMadhab = ref.watch(appSettingsProvider).madhabIndex;

    final List<String> madhabs = [
      "تلقائي (شافعي، مالكي، حنبلي)",
      "حنفي",
    ];

    return SimpleDialog(
      title: const Text(
        "المذهب (صلاة العصر)",
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: "Cairo", fontWeight: FontWeight.bold),
      ),
      children: List.generate(madhabs.length, (index) {
        final bool isSelected = currentMadhab == index;
        return ListTile(
          title: Text(
            madhabs[index],
            style: TextStyle(
              fontFamily: "Cairo",
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
          trailing: isSelected
              ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
              : null,
          onTap: () {
            ref.read(appSettingsProvider.notifier).setMadhab(index);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم تحديث المذهب، يرجى إعادة تشغيل التطبيق لضمان دقة المواعيد.")),
            );
          },
        );
      }),
    );
  }
}
