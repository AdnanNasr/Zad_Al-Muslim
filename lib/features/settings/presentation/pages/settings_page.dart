import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/constants/env.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/l10n/app_localizations.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';
import 'package:zad_al_muslim/core/common/widgets/settings_card.dart';
import 'package:zad_al_muslim/core/common/widgets/settings_container.dart';
import 'package:zad_al_muslim/features/settings/presentation/pages/change_app_color_page.dart';
import 'package:zad_al_muslim/core/themes/theme_notifier.dart';

import 'package:zad_al_muslim/features/settings/presentation/widgets/prayer_notification_selection_dialog.dart';
import 'package:zad_al_muslim/features/settings/presentation/providers/app_settings_provider.dart';
import 'package:zad_al_muslim/features/settings/presentation/widgets/font_size_dialog.dart';
import 'package:zad_al_muslim/features/settings/presentation/widgets/calculation_method_dialog.dart';
import 'package:zad_al_muslim/features/settings/presentation/widgets/madhab_dialog.dart';
import 'package:zad_al_muslim/features/pray_time/presentation/providers/pray_times_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zad_al_muslim/core/common/providers/user_position_provider.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/utils/location/location_locator.dart';
import 'package:zad_al_muslim/features/pray_time/presentation/providers/user_address_provider.dart';
import 'package:zad_al_muslim/domain/usecases/recalculate_and_schedule_usecase.dart';
import 'package:zad_al_muslim/domain/entities/location.dart' as domain_loc;
import 'package:flutter_timezone/flutter_timezone.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  // this varibale belong to clean space
  // bool _isClearingCache = false;
  bool _isUpdatingLocation = false;

  Future<void> _deleteLocationData(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "حذف بيانات الموقع",
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        content: const Text(
          "إذا تابعت في حذف بيانات الموقع الخاصة بك، قد لا تعمل أوقات الصلاة واتجاه القبلة بشكل صحيح.\nهل أنت متأكد من الحذف؟",
          style: TextStyle(fontFamily: 'Cairo', height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll<Color>(
                context.color.onSurface,
              ),
            ),
            child: const Text("إلغاء", style: TextStyle(fontFamily: 'Cairo')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await sl<LocationLocatorImpl>().clearLocationData();
      ref.invalidate(userPositionProvider);
      ref.invalidate(userAddressProvider);
      ref.invalidate(todayPrayerTimesProvider);
      ref.invalidate(selectedDatePrayerTimesProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "تم حذف بيانات الموقع بنجاح",
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: context.color.tertiary,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "حدث خطأ أثناء حذف البيانات",
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: context.color.error,
          ),
        );
      }
    }
  }

  Future<void> _updateLocationData(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "تحديث بيانات الموقع",
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        content: const Text(
          "سيتم جلب إحداثيات الموقع الخاصة بك لاستخدامها في ميزات أوقات الصلاة واتجاه القبلة، وسيتم حفظها محلياً ولن يكون لأي أحد إمكانية الوصول إلى هذه المعلومات كما هو مذكور في سياسة الخصوصية.\nهل توافق على التحديث؟",
          style: TextStyle(fontFamily: 'Cairo', height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll<Color>(
                context.color.onSurface,
              ),
            ),
            child: const Text("إلغاء", style: TextStyle(fontFamily: 'Cairo')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('موافق'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isUpdatingLocation = true);

    try {
      final locationLocator = sl<LocationLocatorImpl>();
      final posResult = await locationLocator.determinePosition();

      await posResult.fold(
        (failure) async {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  failure.message,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                backgroundColor: context.color.error,
              ),
            );
          }
        },
        (position) async {
          ref.read(userPositionProvider.notifier).state = position;

          final tz = (await FlutterTimezone.getLocalTimezone()).toString();
          final recalculateUseCase = sl<RecalculateAndScheduleUseCase>();

          await recalculateUseCase(
            domain_loc.Location(
              latitude: position.latitude,
              longitude: position.longitude,
              timezone: tz,
            ),
          );

          ref.invalidate(todayPrayerTimesProvider);
          ref.invalidate(selectedDatePrayerTimesProvider);
          ref.invalidate(userAddressProvider);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  "تم تحديث بيانات الموقع بنجاح",
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                backgroundColor: context.color.tertiary,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "حدث خطأ أثناء تحديث الموقع",
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: context.color.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdatingLocation = false);
    }
  }

  // this method belnog to clean space
  // Future<void> _clearAudioCache(BuildContext context) async {
  //   // إظهار تنبيه للمستخدم
  //   final confirm = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text(
  //         "تنظيف المساحة",
  //         style: TextStyle(fontFamily: 'Cairo'),
  //       ),
  //       content: const Text(
  //         "هل أنت متأكد من رغبتك في مسح الذاكرة المؤقتة للتلاوات الصوتية؟ سيتم تحرير المساحة ولكنك ستحتاج لاتصال بالإنترنت عند الاستماع لها مجدداً.",
  //         style: TextStyle(fontFamily: 'Cairo'),
  //       ),
  //       actions: [
  //         TextButton(
  //           style: ButtonStyle(
  //             foregroundColor: WidgetStatePropertyAll<Color>(
  //               context.color.onSurface,
  //             ),
  //           ),
  //           onPressed: () => Navigator.pop(context, false),
  //           child: const Text("إلغاء", style: TextStyle(fontFamily: 'Cairo')),
  //         ),
  //         ElevatedButton(
  //           onPressed: () => Navigator.pop(context, true),
  //           style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
  //           child: const Text(
  //             "تأكيد ومسح",
  //             style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );

  //   if (confirm != true) return;

  //   setState(() => _isClearingCache = true);

  //   try {
  //     final List<Directory> dirsToScan = [];

  //     // جلب جميع المجلدات المحتملة للتخزين المؤقت
  //     try {
  //       dirsToScan.add(await getTemporaryDirectory());
  //     } catch (e) {
  //       /* ignore */
  //     }

  //     try {
  //       dirsToScan.add(await getApplicationCacheDirectory());
  //     } catch (e) {
  //       /* ignore */
  //     }

  //     int totalDeletedSize = 0;

  //     for (var dir in dirsToScan) {
  //       if (dir.existsSync()) {
  //         final List<FileSystemEntity> entities = dir.listSync(
  //           recursive: true,
  //           followLinks: false,
  //         );
  //         for (FileSystemEntity entity in entities) {
  //           try {
  //             if (entity is File) {
  //               final int fileSize = entity.lengthSync();
  //               entity.deleteSync();
  //               totalDeletedSize += fileSize;
  //             } else if (entity is Directory) {
  //               // قد نرغب في حذف المجلدات الفارغة أيضاً، لكن الحذر مطلوب
  //               // سنترك محرك الحذف يتعامل معها لاحقاً إذا فرغت
  //             }
  //           } catch (e) {
  //             // قد يكون الملف قيد الاستخدام حالياً (خاصة إذا كان المصحف يعمل)
  //             // نتجاهل الخطأ ونستمر في تنظيف باقي الملفات
  //             continue;
  //           }
  //         }

  //         // محاولة حذف المجلدات الفرعية الفارغة لتنظيف أفضل
  //         try {
  //           final List<FileSystemEntity> remainingEntities = dir.listSync(
  //             followLinks: false,
  //           );
  //           for (var sub in remainingEntities) {
  //             if (sub is Directory) {
  //               try {
  //                 sub.deleteSync(recursive: true);
  //               } catch (e) {
  //                 /* ignore */
  //               }
  //             }
  //           }
  //         } catch (e) {
  //           /* ignore */
  //         }
  //       }
  //     }

  //     final kbSize = (totalDeletedSize / 1024).toStringAsFixed(2);

  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(
  //             "تم تنظيف $kbSize كيلوبايت بنجاح!",
  //             style: const TextStyle(fontFamily: 'Cairo'),
  //           ),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text(
  //             "حدث خطأ أثناء تنظيف المساحة.",
  //             style: TextStyle(fontFamily: 'Cairo'),
  //           ),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isClearingCache = false);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final appSettings = ref.watch(appSettingsProvider);
    final appSettingsNotifier = ref.read(appSettingsProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final selectedColor = ref.watch(userThemeProvider);
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(
            child: SafeArea(bottom: false, child: _SettingsHeader()),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 120.h),
            sliver: SliverList.list(
              children: [
                SettingsContainer(
                  title: 'المظهر والقراءة',
                  subtitle: 'خصص شكل التطبيق وتجربة القراءة',
                  icon: Icons.palette_outlined,
                  accentColor: scheme.primary,
                  settingsCards: [
                    SettingCards(
                      icon: const Right(Icons.dark_mode),
                      text: AppLocalizations.of(context)!.dark_mode,
                      subText: themeMode == ThemeMode.dark
                          ? 'الوضع الداكن مفعّل'
                          : 'الوضع الفاتح مفعّل',
                      forgroundColor: scheme.primary,
                      toggle: true,
                      switchValue: themeMode == ThemeMode.dark,
                      onChanged: (_) => ref
                          .read(themeProvider.notifier)
                          .toggleTheme(themeMode),
                    ),
                    SettingCards(
                      icon: const Right(Icons.color_lens),
                      text: AppLocalizations.of(context)!.app_color,
                      subText: 'لون الأزرار والعناصر البارزة',
                      valueText: _getColorName(selectedColor),
                      forgroundColor: selectedColor,
                      onTap: () => showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: true,
                        useSafeArea: true,
                        context: context,
                        builder: (context) => const ChangeAppColorPage(),
                      ),
                    ),
                    SettingCards(
                      icon: const Right(Icons.format_size),
                      text: 'حجم خط الأذكار',
                      subText: 'حجم النص داخل صفحات الأذكار',
                      valueText: '${appSettings.adkarFontSize.round()}',
                      forgroundColor: scheme.primary,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const FontSizeDialog(),
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: 22.h),

                SettingsContainer(
                  title: 'مواقيت الصلاة',
                  subtitle: 'الحساب والمذهب وطريقة عرض الوقت',
                  icon: Icons.mosque_rounded,
                  accentColor: scheme.secondary,
                  settingsCards: [
                    SettingCards(
                      icon: const Right(Icons.calculate_rounded),
                      text: 'طريقة حساب المواقيت',
                      subText: _getCalculationMethodName(
                        appSettings.calculationMethodIndex,
                      ),
                      forgroundColor: scheme.secondary,
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
                      icon: const Right(Icons.account_balance_rounded),
                      text: 'المذهب (صلاة العصر)',
                      valueText: appSettings.madhabIndex == 0
                          ? 'الجمهور'
                          : 'حنفي',
                      subText: appSettings.madhabIndex == 0
                          ? 'شافعي، مالكي، حنبلي'
                          : null,
                      forgroundColor: scheme.secondary,
                      onTap: () async {
                        await showDialog<void>(
                          context: context,
                          builder: (context) => const MadhabDialog(),
                        );
                        ref.invalidate(todayPrayerTimesProvider);
                        ref.invalidate(selectedDatePrayerTimesProvider);
                      },
                    ),
                    SettingCards(
                      icon: const Right(Icons.access_time_filled_outlined),
                      text: 'تنسيق 24 ساعة',
                      subText: appSettings.use24HourFormat
                          ? 'مثال: 18:30'
                          : 'مثال: 6:30 م',
                      forgroundColor: scheme.secondary,
                      toggle: true,
                      switchValue: appSettings.use24HourFormat,
                      onChanged: (value) async {
                        await appSettingsNotifier.toggle24HourFormat();
                      },
                    ),
                  ],
                ),

                SizedBox(height: 22.h),

                SettingsContainer(
                  title: 'الإشعارات والتنبيهات',
                  subtitle: 'تنبيهات الصلاة وأذكار الصباح والمساء',
                  icon: Icons.notifications_active_outlined,
                  accentColor: scheme.tertiary,
                  settingsCards: [
                    SettingCards(
                      icon: const Right(Icons.notifications_active_rounded),
                      text: 'إشعارات الصلاة',
                      subText: appSettings.prayerNotificationsEnabled
                          ? 'التنبيهات مفعّلة'
                          : 'التنبيهات متوقفة',
                      forgroundColor: scheme.tertiary,
                      toggle: true,
                      switchValue: appSettings.prayerNotificationsEnabled,
                      onChanged: (value) async {
                        await appSettingsNotifier.togglePrayerNotifications();
                        ref.invalidate(todayPrayerTimesProvider);
                        ref.invalidate(selectedDatePrayerTimesProvider);
                      },
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      child: appSettings.prayerNotificationsEnabled
                          ? SettingCards(
                              icon: const Right(Icons.tune_rounded),
                              text: 'تخصيص الصلوات',
                              forgroundColor: scheme.tertiary,
                              subText: 'اختر الصلوات التي تريد تنبيهاتها',
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const PrayerNotificationSelectionDialog(),
                                );
                              },
                            )
                          : const SizedBox.shrink(),
                    ),
                    SettingCards(
                      icon: const Right(Icons.wb_sunny_rounded),
                      text: 'أذكار الصباح',
                      subText: appSettings.morningAdkarReminder
                          ? 'اضغط على الصف لتعديل وقت التنبيه'
                          : 'التنبيه متوقف',
                      valueText: appSettings.morningAdkarReminder
                          ? (appSettings.morningAdkarTime ?? 'وقت الفجر')
                          : null,
                      forgroundColor: scheme.tertiary,
                      toggle: true,
                      switchValue: appSettings.morningAdkarReminder,
                      onChanged: (value) async {
                        await appSettingsNotifier.toggleMorningAdkarReminder();
                      },
                      onTap: appSettings.morningAdkarReminder
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
                                await appSettingsNotifier.setMorningAdkarTime(
                                  formattedTime,
                                );
                              } else {
                                await appSettingsNotifier.setMorningAdkarTime(
                                  null,
                                );
                              }
                            }
                          : null,
                    ),
                    SettingCards(
                      icon: const Right(Icons.nightlight_round),
                      text: 'أذكار المساء',
                      subText: appSettings.eveningAdkarReminder
                          ? 'اضغط على الصف لتعديل وقت التنبيه'
                          : 'التنبيه متوقف',
                      valueText: appSettings.eveningAdkarReminder
                          ? (appSettings.eveningAdkarTime ?? 'وقت المغرب')
                          : null,
                      forgroundColor: scheme.tertiary,
                      toggle: true,
                      switchValue: appSettings.eveningAdkarReminder,
                      onChanged: (value) async {
                        await appSettingsNotifier.toggleEveningAdkarReminder();
                      },
                      onTap: appSettings.eveningAdkarReminder
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
                                await appSettingsNotifier.setEveningAdkarTime(
                                  formattedTime,
                                );
                              } else {
                                await appSettingsNotifier.setEveningAdkarTime(
                                  null,
                                );
                              }
                            }
                          : null,
                    ),
                  ],
                ),

                SizedBox(height: 22.h),

                SettingsContainer(
                  title: 'الموقع والخصوصية',
                  subtitle: 'البيانات المستخدمة للصلاة واتجاه القبلة',
                  icon: Icons.location_on_outlined,
                  accentColor: scheme.secondary,
                  settingsCards: [
                    SettingCards(
                      icon: const Right(Icons.my_location_rounded),
                      text: 'تحديث بيانات الموقع',
                      subText: 'إعادة تحديد موقعك وحساب المواقيت',
                      forgroundColor: scheme.secondary,
                      widget: _isUpdatingLocation
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : null,
                      onTap: _isUpdatingLocation
                          ? null
                          : () => _updateLocationData(context),
                    ),
                  ],
                ),

                SizedBox(height: 22.h),

                SettingsContainer(
                  title: 'حول التطبيق',
                  subtitle: 'معلومات زاد المسلم ومشاركته',
                  icon: Icons.info_outline_rounded,
                  accentColor: scheme.primary,
                  settingsCards: [
                    SettingCards(
                      icon: const Right(Icons.app_settings_alt),
                      text: AppLocalizations.of(context)!.app_information,
                      subText: 'الإصدار والتراخيص وسياسة الاستخدام',
                      forgroundColor: scheme.primary,
                      onTap: () => Navigator.of(context).pushNamed("/app_info"),
                    ),
                    SettingCards(
                      icon: const Right(Icons.share),
                      text: 'مشاركة التطبيق',
                      subText: 'شارك زاد المسلم مع من تحب',
                      forgroundColor: scheme.primary,
                      onTap: () {
                        SharePlus.instance.share(
                          ShareParams(
                            text: Platform.isAndroid
                                ? Env.androidAppLink
                                : Env.iOSAppLink,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: 22.h),

                SettingsContainer(
                  title: 'إجراءات حساسة',
                  subtitle: 'هذه الإجراءات تحتاج إلى تأكيد',
                  icon: Icons.warning_amber_rounded,
                  accentColor: scheme.error,
                  settingsCards: [
                    SettingCards(
                      icon: const Right(Icons.location_off_rounded),
                      text: 'حذف بيانات الموقع',
                      subText: 'سيؤثر في الصلاة والقبلة حتى تحديث الموقع',
                      destructive: true,
                      onTap: () => _deleteLocationData(context),
                    ),
                    SettingCards(
                      icon: const Right(Icons.restart_alt_rounded),
                      text: 'إعادة ضبط الإعدادات',
                      subText: 'استعادة جميع الإعدادات الافتراضية',
                      destructive: true,
                      onTap: () =>
                          resetSettingsDialog(context, appSettingsNotifier),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> resetSettingsDialog(
    BuildContext context,
    AppSettingsNotifier appSettingsNotifier,
  ) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.warning_amber_rounded,
          color: context.color.error,
          size: 32,
        ),
        title: const Text('إعادة ضبط الإعدادات'),
        content: const Text(
          'ستعود إعدادات القراءة والصلاة والتنبيهات إلى قيمها الافتراضية. هل تريد المتابعة؟',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll<Color>(
                context.color.onSurface,
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء", style: TextStyle(fontFamily: "Cairo")),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.color.error,
              foregroundColor: context.color.onError,
            ),
            onPressed: () async {
              await appSettingsNotifier.resetSettings();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('إعادة ضبط'),
          ),
        ],
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

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
      child: Row(
        children: [
          Container(
            width: 50.r,
            height: 50.r,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 25.sp,
              color: scheme.onPrimaryContainer,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الإعدادات',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'خصص تجربتك بما يناسب احتياجاتك',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w500,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _getColorName(Color color) {
  const colors = <int, String>{
    0xFF176B70: 'فيروزي',
    0xFF4F6F52: 'زيتوني',
    0xFF345995: 'أزرق ليلي',
    0xFF695783: 'بنفسجي',
    0xFF8A3F4D: 'عنابي',
    0xFF8A6543: 'رملي',
  };

  return colors[color.toARGB32()] ?? 'مخصص';
}
