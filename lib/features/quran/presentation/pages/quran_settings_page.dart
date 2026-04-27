import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/core/common/widgets/settings_card.dart';
import 'package:noor_quran/core/common/widgets/settings_container.dart';
import 'package:noor_quran/core/constants/routes.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/features/quran/presentation/providers/audio_player_provider.dart';
import 'package:noor_quran/features/quran/presentation/widgets/quran_view_type_dialog.dart';
import 'package:noor_quran/features/quran/presentation/widgets/select_qari_dialog.dart';
import 'package:noor_quran/features/quran/presentation/widgets/ayah_delay_dialog.dart';
import 'package:noor_quran/features/quran/presentation/widgets/reading_colors_dialog.dart';
import 'package:noor_quran/features/quran/presentation/providers/quran_settings_provider.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';

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

    // قائمة الألوان المستخرجة
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
            // استخدام التباعد التلقائي بين الحاويات
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- القسم الأول: تجربة القراءة ---
              SettingsContainer(
                title: "تخصيص القراءة والشكل",
                settingsCards: [
                  SettingCards(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(9),
                    ),
                    icon: Right(Icons.palette_rounded),
                    text: "لون خلفية القراءة",
                    widget: Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.3),
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
                    icon: Right(Icons.swipe_vertical_rounded),
                    text: "شكل صفحات القرآن الكريم",
                    onTap: () {
                      showDialog(context: context, builder: (context) => QuranViewTypeDialog(),);
                    },
                  ),
                  SettingCards(
                    icon: Right(Icons.screen_lock_rotation_rounded),
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

              SizedBox(height: 16.h), // مسافة إضافية بين الحاويات
              // --- القسم الثاني: الاستماع والتحفيظ ---
              SettingsContainer(
                title: "الاستماع والتحفيظ",
                settingsCards: [
                  SettingCards(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(9),
                    ),
                    hero: true,
                    heroId: "qari_icon",
                    icon: Right(Icons.spatial_audio_off),
                    text: "اختيار صوت القارئ",
                    subText: currentSelectedQariProvider.name,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SelectQariDialog();
                        },
                      );
                    },
                  ),
                  SettingCards(
                    icon: Right(Icons.timer_rounded),
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
                    icon: Right(Icons.auto_awesome_motion_rounded),
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

              // --- القسم الثالث: إدارة البيانات والدعم ---
              SettingsContainer(
                title: "الإعدادات العامة",
                settingsCards: [
                  SettingCards(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(9),
                    ),
                    icon: Right(Icons.library_books_rounded),
                    text: "تحميل التفاسير",
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.tafseerPage);
                    },
                    trallingIcon: Icons.download,
                  ),
                  SettingCards(
                    icon: Right(Icons.notifications_active_rounded),
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
                              // إذا اختار إلغاء، يرجع للخيار الافتراضي بعد الفجر
                              ref
                                  .read(quranSettingsProvider.notifier)
                                  .setDailyReminderTime(null);
                            }
                          }
                        : null,
                  ),
                ],
              ),

              // إضافة مساحة في الأسفل لضمان عدم اختفاء آخر عنصر خلف أزرار النظام
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
