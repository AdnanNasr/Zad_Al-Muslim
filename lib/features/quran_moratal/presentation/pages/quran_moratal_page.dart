import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:zad_al_muslim/core/constants/enums/qari_names_moratal.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/utils/network/network_info.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/pages/select_qari_surah_page.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/providers/moratal_download_provider.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/widgets/moratal_mini_player.dart';

import '../widgets/internet_error_message.dart';

class QuranMoratalPage extends ConsumerStatefulWidget {
  const QuranMoratalPage({super.key});

  @override
  ConsumerState<QuranMoratalPage> createState() => _QuranMoratalPageState();
}

class _QuranMoratalPageState extends ConsumerState<QuranMoratalPage> {
  @override
  void initState() {
    super.initState();
    // تهيئة حالة التحميل لكل قارئ عند فتح الصفحة
    Future.microtask(() {
      for (final qari in QariNames.allQaris) {
        final params = (qariId: qari['id']!, serverUrl: qari['server']!);
        ref.read(moratalDownloadProvider(params).notifier).initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      endDrawer: Drawer(
        width: 360.w,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow,
                border: Border(
                  bottom: BorderSide(color: scheme.outlineVariant),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(),
                        Builder(
                          builder: (context) {
                            return IconButton(
                              onPressed: () {
                                Scaffold.of(context).closeEndDrawer();
                              },
                              icon: Icon(Icons.close, color: scheme.onSurface),
                              style: IconButton.styleFrom(
                                backgroundColor: scheme.surfaceContainerHigh,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "تحميل القرآن الكريم",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Cairo",
                        color: scheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "حمّل سور القرآن كاملة للاستماع إليها بدون اتصال بالإنترنت في أي وقت.",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Cairo",
                        color: scheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                itemCount: QariNames.allQaris.length,
                itemBuilder: (context, index) {
                  final Map<String, String> qariData =
                      QariNames.allQaris[index];
                  return _QariListTileDrawer(
                    qariData: qariData,
                    isDark: isDark,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Builder(
              builder: (context) => _MoratalHeader(
                onOpenDownloads: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  AnimationLimiter(
                    child: ListView.separated(
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        top: 8.h,
                        bottom: 100.h,
                      ),
                      itemCount: QariNames.allQaris.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final Map<String, String> qariData =
                            QariNames.allQaris[index];
                        return AnimationConfiguration.staggeredList(
                          duration: const Duration(milliseconds: 700),
                          position: index,
                          child: SlideAnimation(
                            curve: Curves.linear,
                            verticalOffset: 50,
                            child: FadeInAnimation(
                              child: _QariListTile(
                                qariData: qariData,
                                isDark: isDark,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10.h,
                    left: 0,
                    right: 0,
                    child: const MoratalMiniPlayer(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoratalHeader extends StatelessWidget {
  const _MoratalHeader({required this.onOpenDownloads});

  final VoidCallback onOpenDownloads;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 8.h),
      child: Row(
        children: [
          IconButton.filledTonal(
            tooltip: 'العودة',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
          SizedBox(width: 10.w),
          Container(
            width: 46.r,
            height: 46.r,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(
              Icons.graphic_eq_rounded,
              color: scheme.onPrimaryContainer,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'القرآن المُرتل',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  'اختر قارئك المفضل واستمع بخشوع',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10.5.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'إدارة التنزيلات',
            onPressed: onOpenDownloads,
            icon: const Icon(Icons.download_for_offline_outlined),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// بطاقة القارئ - Widget منفصل لتحسين الأداء وعزل حالة كل قارئ
// ---------------------------------------------------------------------------

class _QariListTile extends StatelessWidget {
  final Map<String, String> qariData;
  final bool isDark;

  const _QariListTile({required this.qariData, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final serverUrl = qariData['server'] ?? '';
    final String narration;
    if (serverUrl.contains('Warsh')) {
      narration = 'رواية ورش عن نافع';
    } else if (serverUrl.contains('AlDorai')) {
      narration = 'رواية الدوري عن الكسائي';
    } else {
      narration = 'رواية حفص عن عاصم';
    }

    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(20.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SelectQariSurahPage(qariData: qariData),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Row(
            children: [
              // أيقونة القارئ
              Container(
                width: 55.w,
                height: 55.w,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(17.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.spatial_audio_off_rounded,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // اسم القارئ والرواية
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      qariData['name'] ?? '',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        color: context.color.onSurface,
                      ),
                    ),
                    Text(
                      narration,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              // أيقونة سهم الانتقال
              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QariListTileDrawer extends ConsumerWidget {
  final Map<String, String> qariData;
  final bool isDark;

  const _QariListTileDrawer({required this.qariData, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = (qariId: qariData['id']!, serverUrl: qariData['server']!);
    final downloadState = ref.watch(moratalDownloadProvider(params));
    final sizeAsync = ref.watch(qariDownloadedSizeMBProvider(params.qariId));

    final serverUrl = qariData['server'] ?? '';
    final String narration;
    if (serverUrl.contains('Warsh')) {
      narration = 'رواية ورش عن نافع';
    } else if (serverUrl.contains('AlDorai')) {
      narration = 'رواية الدوري عن الكسائي';
    } else {
      narration = 'رواية حفص عن عاصم';
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: downloadState.status == QariDownloadStatus.completed
              ? context.color.tertiary.withValues(alpha: 0.35)
              : downloadState.status == QariDownloadStatus.inProgress
              ? context.color.primary.withValues(alpha: 0.3)
              : context.color.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      color: context.color.surface,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Qari Avatar
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: downloadState.status == QariDownloadStatus.completed
                        ? context.color.tertiaryContainer
                        : isDark
                        ? context.color.primary.withValues(alpha: 0.25)
                        : context.color.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      downloadState.status == QariDownloadStatus.completed
                          ? Icons.check_circle_outline_rounded
                          : Icons.person_rounded,
                      color:
                          downloadState.status == QariDownloadStatus.completed
                          ? context.color.onTertiaryContainer
                          : context.color.primary,
                      size: 24.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Name & Narration
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        qariData['name'] ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          color: context.color.onSurface,
                        ),
                      ),
                      Text(
                        narration,
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontFamily: 'Cairo',
                          color: context.color.onSurface.withValues(alpha: .6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Size status
                sizeAsync.when(
                  data: (size) => size > 0
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: context.color.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            "${size.toStringAsFixed(1)} م.ب",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: context.color.primary,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  error: (e, s) => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                ),
              ],
            ),

            // Progress information or download state
            if (downloadState.status == QariDownloadStatus.inProgress) ...[
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "تحميل سورة ${downloadState.currentSurah} من 114",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Cairo',
                      color: context.color.onSurface.withValues(alpha: .7),
                    ),
                  ),
                  Text(
                    "${downloadState.progressPercent}%",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      color: context.color.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: downloadState.overallProgress,
                  minHeight: 6.h,
                  backgroundColor: context.color.primary.withValues(alpha: .15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.color.primary,
                  ),
                ),
              ),
            ],

            SizedBox(height: 12.h),
            // Action Buttons Row
            Row(
              children: [
                // View Surahs Button
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            SelectQariSurahPage(qariData: qariData),
                      ),
                    );
                  },
                  icon: Icon(Icons.menu_book_rounded, size: 16.sp),
                  label: Text(
                    "عرض السور",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    foregroundColor: context.color.primary,
                  ),
                ),
                const Spacer(),
                // Download Action Button
                _DownloadButton(
                  qariData: qariData,
                  downloadState: downloadState,
                  isDark: isDark,
                  params: params,
                ),
                // Delete Action Button (visible if downloaded or error with files)
                if (downloadState.status == QariDownloadStatus.completed ||
                    (downloadState.status == QariDownloadStatus.error &&
                        downloadState.downloadedCount > 0)) ...[
                  SizedBox(width: 8.w),
                  _DeleteButton(
                    qariData: qariData,
                    downloadedCount: downloadState.downloadedCount,
                    isDark: isDark,
                    params: params,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ?زر التحميل التفاعلي
// ---------------------------------------------------------------------------

class _DownloadButton extends ConsumerWidget {
  final Map<String, String> qariData;
  final QariDownloadState downloadState;
  final bool isDark;
  final ({String qariId, String serverUrl}) params;

  const _DownloadButton({
    required this.qariData,
    required this.downloadState,
    required this.isDark,
    required this.params,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(360),
      onTap: () => _handleDownloadTap(context, ref),
      child: Ink(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: _getButtonColor(context),
          shape: BoxShape.circle,
        ),
        child: _buildButtonChild(context),
      ),
    );
  }

  Color _getButtonColor(BuildContext context) {
    switch (downloadState.status) {
      case QariDownloadStatus.completed:
        return context.color.tertiaryContainer;
      case QariDownloadStatus.error:
        return context.color.errorContainer;
      case QariDownloadStatus.inProgress:
        return context.color.secondaryContainer;
      default:
        return context.color.primaryContainer;
    }
  }

  Widget _buildButtonChild(BuildContext context) {
    switch (downloadState.status) {
      case QariDownloadStatus.completed:
        return Icon(
          Icons.download_done_rounded,
          color: context.color.onTertiaryContainer,
          size: 24.sp,
        );

      case QariDownloadStatus.inProgress:
        return Icon(Icons.pause, color: context.color.onSecondaryContainer);

      case QariDownloadStatus.error:
        return Icon(
          Icons.refresh_rounded,
          color: context.color.onErrorContainer,
          size: 24.sp,
        );

      default:
        return Icon(
          Icons.download_rounded,
          color: context.color.onPrimaryContainer,
          size: 24.sp,
        );
    }
  }

  Future<void> _handleDownloadTap(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(moratalDownloadProvider(params).notifier);

    switch (downloadState.status) {
      case QariDownloadStatus.completed:
        // لا شيء - التحميل مكتمل
        BotToast.cleanAll();

        BotToast.showCustomNotification(
          duration: const Duration(seconds: 4),
          align: const Alignment(0, 0.9), // ظهور في أسفل الشاشة
          toastBuilder: (cancelFunc) {
            return Card(
              margin: EdgeInsets.all(16.w),
              color: Colors.green.shade700, // نفس اللون الأخضر لنجاح العملية
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  children: [
                    const Icon(
                      Icons
                          .offline_pin_rounded, // نفس أيقونة التأكيد المتوفرة أوفلاين
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'تم تحميل جميع السور. يمكنك الاستماع بدون إنترنت!',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        break;

      case QariDownloadStatus.inProgress:
        // عرض Dialog إلغاء التحميل
        final cancel = await _showCancelDialog(context);
        if (cancel == true) {
          BotToast.cleanAll();

          BotToast.showCustomNotification(
            duration: const Duration(seconds: 4),
            align: const Alignment(0, 0.9), // ظهور في أسفل الشاشة
            toastBuilder: (cancelFunc) {
              return Card(
                margin: EdgeInsets.all(16.w),
                color: Colors.red.shade700, // نفس اللون الأخضر لنجاح العملية
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons
                            .pause_sharp, // نفس أيقونة التأكيد المتوفرة أوفلاين
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'تم إيقاف تحميل السور للقارئ ${qariData["name"]}',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          notifier.cancelDownload();
          await WakelockPlus.disable();
          if (!context.mounted) return;
        }
        break;

      case QariDownloadStatus.error:
        // استكمال التحميل
        final confirm = await _showConfirmDialog(context, isResume: true);

        if (confirm == true && context.mounted) {
          BotToast.cleanAll();

          BotToast.showCustomNotification(
            duration: const Duration(seconds: 4),
            align: const Alignment(0, 0.9), // ظهور في أسفل الشاشة
            toastBuilder: (cancelFunc) {
              return Card(
                margin: EdgeInsets.all(16.w),
                color: Colors.green.shade700, // نفس اللون الأخضر لنجاح العملية
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons
                            .replay_outlined, // نفس أيقونة التأكيد المتوفرة أوفلاين
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'جاري إستكمال تحميل السور للقارئ ${qariData["name"]}',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          await WakelockPlus.enable();
          notifier.startDownloadAll().then((_) => WakelockPlus.disable());
        }
        break;

      default:
        // بدء تحميل جديد
        final confirm = await _showConfirmDialog(context, isResume: false);
        if (confirm == true && context.mounted) {
          BotToast.cleanAll();

          BotToast.showCustomNotification(
            duration: const Duration(seconds: 4),
            align: const Alignment(0, 0.9), // ظهور في أسفل الشاشة
            toastBuilder: (cancelFunc) {
              return Card(
                margin: EdgeInsets.all(16.w),
                color: Colors.green.shade700, // نفس اللون الأخضر لنجاح العملية
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.download, // نفس أيقونة التأكيد المتوفرة أوفلاين
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'بدأت عميلة تحميل السور للقارئ ${qariData["name"]}',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          await WakelockPlus.enable();
          notifier.startDownloadAll().then((_) => WakelockPlus.disable());
        }
        break;
    }
  }

  Future<bool?> _showConfirmDialog(
    BuildContext context, {
    required bool isResume,
  }) {
    final qariName = qariData['name'] ?? 'القارئ';
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        titlePadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
        contentPadding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
        actionsPadding: EdgeInsets.all(16.w),
        title: Row(
          children: [
            Icon(
              Icons.download_rounded,
              color: context.color.primary,
              size: 26.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                isResume ? 'استكمال التحميل' : 'تحميل سور القرآن',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isResume
                  ? 'سيتم استكمال تحميل سور القرآن الكريم بصوت $qariName من حيث توقف.'
                  : 'سيتم تحميل جميع سور القرآن الكريم (١١٤ سورة) بصوت $qariName على جهازك.',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13.5.sp,
                height: 1.6,
              ),
            ),
            SizedBox(height: 14.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: context.color.primary.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: context.color.primary.withValues(alpha: .3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: isDark
                            ? context.color.onSurface
                            : context.color.primary,
                        size: 18,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'هذه العملية قد تستهلك ما بين ٥٠٠ ميجابايت إلى ٢ جيجابايت من بيانات الإنترنت.',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12.sp,
                            color: isDark
                                ? context.color.onSurface
                                : context.color.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.phone_android_rounded,
                        color: isDark
                            ? context.color.onSurface
                            : context.color.primary,
                        size: 18,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'يرجى ترك التطبيق مفتوحاً حتى اكتمال التحميل. يمكنك الاستكمال في أي وقت إذا أُغلق التطبيق.',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12.sp,
                            color: isDark
                                ? context.color.onSurface
                                : context.color.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                color: Colors.grey,
              ),
            ),
          ),
          FilledButton(
            onPressed: () async {
              final hasInternet = await NetworkInfo().hasValidConnection();

              if (!hasInternet) {
                if (!context.mounted) return;
                InternetErrorMessage.showMessage(context: ctx);
              }

              if (!ctx.mounted) return;
              Navigator.of(ctx).pop(true);
            },
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              isResume ? 'استكمال' : 'تحميل الآن',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showCancelDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'إيقاف التحميل',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        content: Text(
          'هل تريد إيقاف التحميل؟\nسيتم حفظ السور التي تم تحميلها بالفعل، ويمكنك الاستكمال لاحقاً.',
          style: TextStyle(fontFamily: 'Cairo', fontSize: 13.sp, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'متابعة التحميل',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'إيقاف',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// !زر الحذف
// ---------------------------------------------------------------------------

class _DeleteButton extends ConsumerWidget {
  final Map<String, String> qariData;
  final int downloadedCount;
  final bool isDark;
  final ({String qariId, String serverUrl}) params;

  const _DeleteButton({
    required this.qariData,
    required this.downloadedCount,
    required this.isDark,
    required this.params,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(360),
      onTap: () => _handleDeleteTap(context, ref),
      child: Ink(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: isDark ? 0.7 : 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: isDark ? Colors.red.shade100 : Colors.red.shade600,
          size: 22.sp,
        ),
      ),
    );
  }

  Future<void> _handleDeleteTap(BuildContext context, WidgetRef ref) async {
    final qariName = qariData['name'] ?? 'القارئ';
    final confirm = await _showDeleteConfirmDialog(context, qariName);
    if (confirm == true && context.mounted) {
      await ref
          .read(moratalDownloadProvider(params).notifier)
          .deleteAllDownloads();

      if (context.mounted) {
        BotToast.cleanAll();

        BotToast.showCustomNotification(
          duration: const Duration(seconds: 4),
          align: const Alignment(0, 0.9), // ظهور في أسفل الشاشة
          toastBuilder: (cancelFunc) {
            return Card(
              margin: EdgeInsets.all(16.w),
              color: Colors.red.shade700, // نفس اللون الأحمر المخصص للحذف
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_sweep_rounded, // أيقونة معبرة عن حذف الكل
                      color: Colors.white,
                      size: 22,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'تم حذف جميع سور $qariName من الجهاز.',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
  }

  Future<bool?> _showDeleteConfirmDialog(
    BuildContext context,
    String qariName,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.delete_outline_rounded,
              color: Colors.red.shade600,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'حذف السور المُحمَّلة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'سيتم حذف $downloadedCount سورة مُحمَّلة بصوت $qariName من جهازك.\nلا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(fontFamily: 'Cairo', fontSize: 13.sp, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                color: Colors.grey,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'حذف',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
