import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';
import 'package:noor_quran/features/settings/presentation/pages/change_app_color_page.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/core/common/widgets/settings_card.dart';
import 'package:noor_quran/core/common/widgets/settings_container.dart';
import 'package:noor_quran/features/settings/presentation/widgets/adahn_dialog.dart';
import 'package:noor_quran/features/settings/presentation/widgets/language_dialog.dart';
import 'package:noor_quran/features/settings/presentation/providers/app_settings_provider.dart';
import 'package:noor_quran/features/settings/presentation/widgets/font_size_dialog.dart';
import 'package:noor_quran/features/settings/presentation/widgets/calculation_method_dialog.dart';
import 'package:noor_quran/features/settings/presentation/widgets/madhab_dialog.dart';
import 'package:noor_quran/features/pray_time/presentation/providers/pray_times_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  double currentValue = 50;

  bool _isClearingCache = false;

  Future<void> _clearAudioCache(BuildContext context) async {
    // إظهار تنبيه للمستخدم
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "تنظيف المساحة",
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        content: const Text(
          "هل أنت متأكد من رغبتك في مسح الذاكرة المؤقتة للتلاوات الصوتية؟ سيتم تحرير المساحة ولكنك ستحتاج لاتصال بالإنترنت عند الاستماع لها مجدداً.",
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("إلغاء", style: TextStyle(fontFamily: 'Cairo')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              "تأكيد ومسح",
              style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isClearingCache = true);

    try {
      final List<Directory> dirsToScan = [];

      // جلب جميع المجلدات المحتملة للتخزين المؤقت
      try {
        dirsToScan.add(await getTemporaryDirectory());
      } catch (e) {
        /* ignore */
      }

      try {
        dirsToScan.add(await getApplicationCacheDirectory());
      } catch (e) {
        /* ignore */
      }

      int totalDeletedSize = 0;

      for (var dir in dirsToScan) {
        if (dir.existsSync()) {
          final List<FileSystemEntity> entities = dir.listSync(
            recursive: true,
            followLinks: false,
          );
          for (FileSystemEntity entity in entities) {
            try {
              if (entity is File) {
                final int fileSize = entity.lengthSync();
                entity.deleteSync();
                totalDeletedSize += fileSize;
              } else if (entity is Directory) {
                // قد نرغب في حذف المجلدات الفارغة أيضاً، لكن الحذر مطلوب
                // سنترك محرك الحذف يتعامل معها لاحقاً إذا فرغت
              }
            } catch (e) {
              // قد يكون الملف قيد الاستخدام حالياً (خاصة إذا كان المصحف يعمل)
              // نتجاهل الخطأ ونستمر في تنظيف باقي الملفات
              continue;
            }
          }

          // محاولة حذف المجلدات الفرعية الفارغة لتنظيف أفضل
          try {
            final List<FileSystemEntity> remainingEntities = dir.listSync(
              followLinks: false,
            );
            for (var sub in remainingEntities) {
              if (sub is Directory) {
                try {
                  sub.deleteSync(recursive: true);
                } catch (e) {
                  /* ignore */
                }
              }
            }
          } catch (e) {
            /* ignore */
          }
        }
      }

      final mbSize = (totalDeletedSize / (1024 * 1024)).toStringAsFixed(2);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "تم تنظيف $mbSize ميغابايت بنجاح!",
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "حدث خطأ أثناء تنظيف المساحة.",
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isClearingCache = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final appSettings = ref.watch(appSettingsProvider);
    final appSettingsNotifier = ref.read(appSettingsProvider.notifier);
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
                    icon: Right(Icons.language),
                    text: AppLocalizations.of(context)!.app_language,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const LanguageDialog(),
                      );
                    },
                  ),
                  SettingCards(
                    icon: Right(Icons.dark_mode),
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
                    icon: Right(Icons.color_lens),
                    text: AppLocalizations.of(context)!.app_color,
                    onTap: () => showModalBottomSheet(
                      isDismissible: true,
                      context: context,
                      builder: (context) => const ChangeAppColorPage(),
                    ),
                  ),
                  SettingCards(
                    icon: Right(Icons.format_size),
                    text: "حجم خط الأذكار",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const FontSizeDialog(),
                      );
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
                    icon: Right(Icons.calculate_rounded),
                    text: "طريقة حساب المواقيت",
                    subText: _getCalculationMethodName(
                      appSettings.calculationMethodIndex,
                    ),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => const CalculationMethodDialog(),
                      );
                      ref.invalidate(todayPrayerTimesProvider);
                      ref.invalidate(selectedDatePrayerTimesProvider);
                    },
                  ),
                  SettingCards(
                    icon: Left(
                      Hero(
                        tag: "mosque",
                        child: Icon(
                          Icons.mosque_rounded,
                          size: context.witdthScreen * 0.08,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    text: "المذهب (صلاة العصر)",
                    subText: appSettings.madhabIndex == 0
                        ? "تلقائي (شافعي، مالكي، حنبلي)"
                        : "حنفي",
                    onTap: () async {
                      await Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          barrierDismissible: true,
                          barrierColor: Colors.black45,
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const MadhabDialog(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                        ),
                      );
                      ref.invalidate(todayPrayerTimesProvider);
                      ref.invalidate(selectedDatePrayerTimesProvider);
                    },
                  ),
                  SettingCards(
                    icon: Right(Icons.access_time_filled_outlined),
                    text: "تنسيق الوقت (24 ساعة)",
                    toggle: true,
                    switchValue: appSettings.use24HourFormat,
                    onChanged: (value) async {
                      await appSettingsNotifier.toggle24HourFormat();
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
                    icon: Right(Icons.notifications_active_rounded),
                    text: "إشعارات الصلاة",
                    toggle: true,
                    switchValue: appSettings.prayerNotificationsEnabled,
                    onChanged: (value) async {
                      await appSettingsNotifier.togglePrayerNotifications();
                      ref.invalidate(todayPrayerTimesProvider);
                      ref.invalidate(selectedDatePrayerTimesProvider);
                    },
                  ),
                  SettingCards(
                    icon: Right(Icons.multitrack_audio_sharp),
                    text: "صوت الأذان",
                    subText: "الافتراضي",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AdahnDialog(),
                      );
                    },
                  ),
                  SettingCards(
                    icon: Right(Icons.wb_sunny_rounded),
                    text: "تنبيه أذكار الصباح",
                    toggle: true,
                    switchValue: appSettings.morningAdkarReminder,
                    onChanged: (value) async {
                      await appSettingsNotifier.toggleMorningAdkarReminder();
                      ref.invalidate(todayPrayerTimesProvider);
                      ref.invalidate(selectedDatePrayerTimesProvider);
                    },
                  ),
                  SettingCards(
                    icon: Right(Icons.nightlight_round),
                    text: "تنبيه أذكار المساء",
                    toggle: true,
                    switchValue: appSettings.eveningAdkarReminder,
                    onChanged: (value) async {
                      await appSettingsNotifier.toggleEveningAdkarReminder();
                      ref.invalidate(todayPrayerTimesProvider);
                      ref.invalidate(selectedDatePrayerTimesProvider);
                    },
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // --- 4. إعدادات عامة ---
              SettingsContainer(
                title: "إعدادات عامة",
                settingsCards: [
                  SettingCards(
                    icon: Right(Icons.vibration),
                    text: "اهتزاز التسبيح (Haptic)",
                    toggle: true,
                    switchValue: appSettings.hapticFeedbackEnabled,
                    onChanged: (value) async {
                      await appSettingsNotifier.toggleHapticFeedback();
                    },
                  ),
                  SettingCards(
                    icon: Right(Icons.restart_alt_rounded),
                    text: "إعادة ضبط جميع الإعدادات",
                    forgroundColor: Colors.red,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            "تأكيد",
                            style: TextStyle(fontFamily: "Cairo"),
                          ),
                          content: const Text(
                            "هل أنت متأكد من إعادة ضبط جميع الإعدادات العامة؟",
                            style: TextStyle(fontFamily: "Cairo"),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "إلغاء",
                                style: TextStyle(fontFamily: "Cairo"),
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll<Color>(
                                  Colors.red,
                                ),
                              ),
                              onPressed: () async {
                                await appSettingsNotifier.resetSettings();
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text(
                                "إعادة ضبط",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Cairo",
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SettingCards(
                    icon: Right(Icons.cleaning_services_rounded),
                    text: "تنظيف المساحة",
                    widget: _isClearingCache
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                    onTap: _isClearingCache
                        ? null
                        : () => _clearAudioCache(context),

                    trallingIcon: Icons.delete,
                  ),
                  SettingCards(
                    icon: Right(Icons.app_settings_alt),
                    text: AppLocalizations.of(context)!.app_information,
                    onTap: () => Navigator.of(context).pushNamed("/app_info"),
                  ),
                  SettingCards(
                    icon: Right(Icons.group),
                    text: "نشر التطبيق (صدقة جارية)",
                    onTap: () {
                      SharePlus.instance.share(
                        ShareParams(text: "https://noor_bayan.com"),
                      );
                    },
                  ),
                ],
              ),
              // مساحة إضافية في الأسفل
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  String _getCalculationMethodName(int index) {
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
    return index < methods.length ? methods[index] : methods[0];
  }
}
