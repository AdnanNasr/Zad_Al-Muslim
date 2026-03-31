import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';
import 'package:noor_quran/features/settings/presentation/pages/change_app_color_page.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/features/settings/presentation/widgets/language_dialog.dart';
import 'package:noor_quran/features/settings/presentation/widgets/settings_card.dart';
import 'package:noor_quran/features/settings/presentation/widgets/settings_container.dart';

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
              SettingsContainer(
                title: AppLocalizations.of(context)!.app_settings,
                settingsCards: [
                  SettingCards(
                    icon: Icons.language,
                    text: AppLocalizations.of(context)!.language,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const LanguageDialog();
                        },
                      );
                    },
                  ),
                  SettingCards(
                    icon: Icons.access_time_filled_outlined,
                    text: AppLocalizations.of(context)!.active_24_format,
                    toggle: true,
                  ),
                  SettingCards(
                    icon: Icons.dark_mode,
                    text: AppLocalizations.of(context)!.dark_mode,
                    toggle: true,
                    onChanged: (_) async {
                      await ref
                          .read(themeProvider.notifier)
                          .toggleTheme(themeMode);
                    },
                  ),
                  SettingCards(
                    icon: Icons.font_download,
                    text: AppLocalizations.of(context)!.font_size,
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
                    icon: Icons.app_settings_alt,
                    text: AppLocalizations.of(context)!.app_information,
                    onTap: () => Navigator.of(context).pushNamed("/app_info"),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                  ),
                  SettingCards(
                    icon: Icons.screenshot,
                    text: "حجم الشاشة",
                    onTap: () {
                      final screenWidthSize = ScreenUtil().screenWidth;
                      final screenHeightSize = ScreenUtil().screenHeight;
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            backgroundColor: context.color.primary,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "عرض الشاشة: $screenWidthSize\nارتفاع الشاشة: $screenHeightSize",
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    color: context.color.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
