import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/core/common/widgets/settings_card.dart';
import 'package:noor_quran/core/common/widgets/settings_container.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/features/quran/presentation/providers/audio_player_provider.dart';
import 'package:noor_quran/features/quran/presentation/widgets/select_qari_dialog.dart';
import 'package:noor_quran/features/quran/presentation/widgets/ayah_delay_dialog.dart';
import 'package:noor_quran/features/quran/presentation/providers/quran_settings_provider.dart';
import 'package:path_provider/path_provider.dart';

class QuranSettingsPage extends ConsumerStatefulWidget {
  const QuranSettingsPage({super.key});

  @override
  ConsumerState<QuranSettingsPage> createState() => _QuranSettingsPageState();
}

class _QuranSettingsPageState extends ConsumerState<QuranSettingsPage> {
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
    final settings = ref.watch(quranSettingsProvider);
    final currentSelectedQariProvider = ref.watch(selectedQariProvider);
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
                    icon: Icons.palette_rounded,
                    text: "لون خلفية القراءة",
                    onTap: () {
                      // هنا تفتح Modal الألوان التي صممناها سابقاً
                    },
                  ),
                  SettingCards(
                    icon: Icons.screen_lock_rotation_rounded,
                    text: "بقاء الشاشة مضيئة أثناء القراءة",
                    toggle: true,
                    switchValue: settings.keepScreenAwake,
                    onChanged: (_) {
                      ref
                          .read(quranSettingsProvider.notifier)
                          .toggleKeepScreenAwake();
                    },
                  ),
                  SettingCards(
                    icon: Icons.ads_click_rounded,
                    text: "التقليب باستخدام أزرار الصوت",
                    onChanged: (vlaue) {},
                    toggle: true,
                  ),
                ],
              ),

              SizedBox(height: 16.h), // مسافة إضافية بين الحاويات
              // --- القسم الثاني: الاستماع والتحفيظ ---
              SettingsContainer(
                title: "الاستماع والتحفيظ",
                settingsCards: [
                  SettingCards(
                    hero: true,
                    heroId: "qari_icon",
                    icon: Icons.spatial_audio_off,
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
                    icon: Icons.timer_rounded,
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
                    trallingIcon: Icons.edit,
                  ),
                  SettingCards(
                    icon: Icons.auto_awesome_motion_rounded,
                    text: "التمرير التلقائي مع صوت القارئ",
                    toggle: true,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // --- القسم الثالث: إدارة البيانات والدعم ---
              SettingsContainer(
                title: "إدارة التطبيق",
                settingsCards: [
                  SettingCards(
                    icon: Icons.cleaning_services_rounded,
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
                  ),
                  SettingCards(
                    icon: Icons.notifications_active_rounded,
                    text: "تنبيهات ورد القراءة اليومي",
                    toggle: true,
                  ),
                  SettingCards(
                    icon: Icons.group,
                    text: "نشر التطبيق (صدقة جارية)",
                    trallingIcon: Icons.share,
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
