import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/common/widgets/custom_app_bar.dart';
import 'package:zad_al_muslim/core/common/widgets/settings_card.dart';
import 'package:zad_al_muslim/core/common/widgets/settings_container.dart';
import 'package:zad_al_muslim/core/constants/routes.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/extensions/sizes_ext.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/audio_player_provider.dart';
import 'package:zad_al_muslim/features/quran/presentation/widgets/quran_view_type_dialog.dart';
import 'package:zad_al_muslim/features/quran/presentation/widgets/select_qari_dialog.dart';
import 'package:zad_al_muslim/features/quran/presentation/widgets/ayah_delay_dialog.dart';
import 'package:zad_al_muslim/features/quran/presentation/widgets/reading_colors_dialog.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/quran_settings_provider.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';

class QuranSettingsPage extends ConsumerStatefulWidget {
  const QuranSettingsPage({super.key});

  @override
  ConsumerState<QuranSettingsPage> createState() => _QuranSettingsPageState();
}

class _QuranSettingsPageState extends ConsumerState<QuranSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(quranSettingsProvider);
    final currentSelectedQariProvider = ref.watch(selectedQariProvider);
    final themeMode = ref.watch(themeProvider);
    final theme = Theme.of(context);
    final isDark =
        themeMode == ThemeMode.dark || theme.brightness == Brightness.dark;

    final List<Color> currentColorsList = isDark
        ? [
            const Color(0xFF1E1E1E),
            const Color(0xFF000000),
            const Color(0xFF2C241B),
            const Color(0xFF111A22),
          ]
        : [
            const Color(0xFFF5E6D3),
            const Color(0xFFFFFFFF),
            const Color(0xFFF5F5F5),
            const Color(0xFFFAF6EE),
          ];

    final Color selectedColor =
        currentColorsList[settings.readingBackgroundColorIndex.clamp(
          0,
          currentColorsList.length - 1,
        )];

    return Scaffold(
      appBar: const CustomAppBar(
        title: "إعدادات القرآن الكريم",
        center: false,
        profile: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(context.heightScreen * 0.015),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsContainer(
                title: "تخصيص القراءة والشكل",
                settingsCards: [
                  SettingCards(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(9),
                    ),
                    icon: const Right(Icons.palette_rounded),
                    text: "لون خلفية القراءة",
                    widget: Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.color.onSurface.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const ReadingColorsDialog(),
                      );
                    },
                  ),
                  SettingCards(
                    icon: const Right(Icons.swipe_vertical_rounded),
                    text: "شكل صفحات القرآن الكريم",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const QuranViewTypeDialog(),
                      );
                    },
                  ),
                  SettingCards(
                    icon: const Right(Icons.screen_lock_rotation_rounded),
                    text: "بقاء الشاشة مضيئة أثناء القراءة",
                    toggle: true,
                    switchValue: settings.keepScreenAwake,
                    onChanged: (_) {
                      ref
                          .read(quranSettingsProvider.notifier)
                          .toggleKeepScreenAwake();
                    },
                  ),
                ],
              ),

              SizedBox(height: 16.h),
              SettingsContainer(
                title: "الاستماع والتحفيظ",
                settingsCards: [
                  SettingCards(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(9),
                    ),
                    hero: true,
                    heroId: "qari_icon",
                    icon: const Right(Icons.spatial_audio_off),
                    text: "اختيار صوت القارئ",
                    subText: currentSelectedQariProvider.name,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const SelectQariDialog();
                        },
                      );
                    },
                  ),
                  SettingCards(
                    icon: const Right(Icons.timer_rounded),
                    text: "الفاصل الزمني بين الآيات",
                    subText: settings.ayahDelaySeconds == 0
                        ? 'بدون توقف'
                        : '${settings.ayahDelaySeconds} ثوانٍ',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AyahDelayDialog(),
                      );
                    },
                  ),
                  SettingCards(
                    icon: const Right(Icons.auto_awesome_motion_rounded),
                    text: "التمرير التلقائي مع صوت القارئ",
                    toggle: true,
                    switchValue: settings.autoScrollWithAudio,
                    onChanged: (_) {
                      ref
                          .read(quranSettingsProvider.notifier)
                          .toggleAutoScrollWithAudio();
                    },
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              SettingsContainer(
                title: "الإعدادات العامة",
                settingsCards: [
                  SettingCards(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(9),
                    ),
                    icon: const Right(Icons.library_books_rounded),
                    text: "تحميل التفاسير",
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.tafseerPage);
                    },
                    trallingIcon: Icons.download,
                  ),
                  SettingCards(
                    icon: const Right(Icons.notifications_active_rounded),
                    text: "تنبيهات ورد القراءة اليومي",
                    subText: settings.isDailyReminderEnabled
                        ? (settings.dailyReminderTime != null
                              ? "الوقت: ${settings.dailyReminderTime}"
                              : "الوقت: بعد الفجر")
                        : "اضغط هنا لتحديد وقت التذكير",
                    toggle: true,
                    switchValue: settings.isDailyReminderEnabled,
                    onChanged: (_) {
                      ref
                          .read(quranSettingsProvider.notifier)
                          .toggleDailyReminder();
                    },
                    onTap: settings.isDailyReminderEnabled
                        ? () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              helpText:
                                  'اختر وقت التنبيه (أو إلغاء للرجوع للمقترح)',
                            );
                            if (time != null) {
                              final formattedTime =
                                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                              ref
                                  .read(quranSettingsProvider.notifier)
                                  .setDailyReminderTime(formattedTime);
                            } else {
                              ref
                                  .read(quranSettingsProvider.notifier)
                                  .setDailyReminderTime(null);
                            }
                          }
                        : null,
                  ),
                ],
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
