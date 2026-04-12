import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';
import 'package:noor_quran/features/settings/presentation/pages/change_app_color_page.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/core/common/widgets/settings_card.dart';
import 'package:noor_quran/core/common/widgets/settings_container.dart';
import 'package:noor_quran/features/settings/presentation/widgets/language_dialog.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  double currentValue = 50;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.settings,
        center: false,
        profile: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.heightScreen * 0.015),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- 1. إعدادات التطبيق ---
              SettingsContainer(
                title: AppLocalizations.of(context)!.app_settings,
                settingsCards: [
                  SettingCards(
                    icon: Icons.language,
                    text: AppLocalizations.of(context)!.app_language,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const LanguageDialog(),
                      );
                    },
                  ),
                  SettingCards(
                    icon: Icons.dark_mode,
                    text: AppLocalizations.of(context)!.dark_mode,
                    toggle: true,
                    switchValue: themeMode == ThemeMode.dark,
                    onChanged: (value) async {
                      await ref
                          .read(themeProvider.notifier)
                          .toggleTheme(themeMode);
                    },
                  ),
                  SettingCards(
                    icon: Icons.color_lens,
                    text: AppLocalizations.of(context)!.app_color,
                    onTap: () => showModalBottomSheet(
                      isDismissible: true,
                      context: context,
                      builder: (context) => const ChangeAppColorPage(),
                    ),
                  ),
                  SettingCards(
                    icon: Icons.format_size,
                    text: "حجم خط الأذكار",
                    onTap: () {
                      // TODO: Implement Font Size Slider
                    },
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // --- 2. إعدادات الصلاة ---
              SettingsContainer(
                title: "إعدادات مواقيت الصلاة",
                settingsCards: [
                  SettingCards(
                    icon: Icons.calculate_rounded,
                    text: "طريقة حساب المواقيت",
                    subText: "تلقائي (بناءً على الموقع)",
                    onTap: () {
                      // TODO: Show Calculation Methods Dialog
                    },
                  ),
                  SettingCards(
                    icon: Icons.mosque_rounded,
                    text: "المذهب (صلاة العصر)",
                    subText: "شافعي، مالكي، حنبلي",
                    onTap: () {
                      // TODO: Show Madhab Selection Dialog
                    },
                  ),
                  SettingCards(
                    icon: Icons.access_time_filled_outlined,
                    text: "تنسيق الوقت (24 ساعة)",
                    toggle: true,
                    switchValue: false, // TODO: Link to provider
                    onChanged: (value) {
                      // TODO: Toggle time format
                    },
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // --- 3. الإشعارات والتنبيهات ---
              SettingsContainer(
                title: "الإشعارات والتنبيهات",
                settingsCards: [
                  SettingCards(
                    icon: Icons.notifications_active_rounded,
                    text: "إشعارات الصلاة",
                    toggle: true,
                    switchValue: true, // TODO: Link to provider
                    onChanged: (value) {},
                  ),
                  SettingCards(
                    icon: Icons.multitrack_audio_sharp,
                    text: "صوت الأذان",
                    subText: "الافتراضي",
                    onTap: () {
                      // TODO: Show Athan Sound Selection
                    },
                  ),
                  SettingCards(
                    icon: Icons.wb_sunny_rounded,
                    text: "تنبيه أذكار الصباح والمساء",
                    toggle: true,
                    switchValue: false, // TODO: Link to provider
                    onChanged: (value) {},
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // --- 4. إعدادات عامة ---
              SettingsContainer(
                title: "إعدادات عامة",
                settingsCards: [
                  SettingCards(
                    icon: Icons.vibration,
                    text: "اهتزاز التسبيح (Haptic)",
                    toggle: true,
                    switchValue: true, // TODO: Link to provider
                    onChanged: (value) {},
                  ),
                  SettingCards(
                    icon: Icons.restart_alt_rounded,
                    text: "إعادة ضبط جميع الإعدادات",
                    forgroundColor: Colors.red,
                    onTap: () {
                      // TODO: Show Confirmation Dialog
                    },
                  ),
                  SettingCards(
                    icon: Icons.app_settings_alt,
                    text: AppLocalizations.of(context)!.app_information,
                    onTap: () => Navigator.of(context).pushNamed("/app_info"),
                  ),
                ],
              ),
              // مساحة إضافية في الأسفل
              // SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
