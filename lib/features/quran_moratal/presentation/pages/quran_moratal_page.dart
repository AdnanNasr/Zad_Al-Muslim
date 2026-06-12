import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';
import 'package:zad_al_muslim/core/common/widgets/custom_app_bar.dart';
import 'package:zad_al_muslim/core/constants/enums/qari_names_moratal.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/pages/select_qari_surah_page.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/providers/moratal_download_provider.dart';

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
    final themeMode = ref.watch(themeProvider);
    final bool isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'القرآن مُرتل',
        center: false,
        themeMode: false,
      ),
      body: AnimationLimiter(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          itemCount: QariNames.allQaris.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final Map<String, String> qariData = QariNames.allQaris[index];
            return AnimationConfiguration.staggeredList(
              duration: const Duration(milliseconds: 700),
              position: index,
              child: SlideAnimation(
                curve: Curves.linear,
                verticalOffset: 50,
                child: FadeInAnimation(
                  child: _QariListTile(qariData: qariData, isDark: isDark),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// بطاقة القارئ - Widget منفصل لتحسين الأداء وعزل حالة كل قارئ
// ---------------------------------------------------------------------------

class _QariListTile extends ConsumerWidget {
  final Map<String, String> qariData;
  final bool isDark;

  const _QariListTile({required this.qariData, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = (qariId: qariData['id']!, serverUrl: qariData['server']!);
    final downloadState = ref.watch(moratalDownloadProvider(params));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SelectQariSurahPage(qariData: qariData),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: context.color.primary.withValues(alpha: .3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // أيقونة القارئ
              Container(
                width: 55.w,
                height: 55.w,
                decoration: BoxDecoration(
                  color: isDark
                      ? context.color.primary.withValues(alpha: .7)
                      : context.color.primary.withValues(alpha: .1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.spatial_audio_off_rounded,
                    color: isDark
                        ? context.color.onSurface
                        : context.color.primary,
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
                      'رواية حفص عن عاصم',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? context.color.onSurface.withValues(alpha: .8)
                            : context.color.onSurface.withValues(alpha: .6),
                      ),
                    ),

                    // شريط التقدم عند التحميل
                    if (downloadState.status ==
                        QariDownloadStatus.inProgress) ...[
                      SizedBox(height: 6.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: downloadState.overallProgress,
                          minHeight: 4.h,
                          backgroundColor: context.color.primary.withValues(
                            alpha: .15,
                          ),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            context.color.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              // أزرار التحميل والحذف
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // زر التحميل التفاعلي
                  _DownloadButton(
                    qariData: qariData,
                    downloadState: downloadState,
                    isDark: isDark,
                    params: params,
                  ),

                  // زر الحذف (يظهر فقط عند اكتمال التحميل أو وجود ملفات)
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
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// زر التحميل التفاعلي
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
        return Colors.green.withValues(alpha: isDark ? 0.8 : 0.15);
      case QariDownloadStatus.error:
        return Colors.orange.withValues(alpha: isDark ? 0.8 : 0.15);
      case QariDownloadStatus.inProgress:
        return context.color.primary.withValues(alpha: isDark ? 0.7 : 0.1);
      default:
        return context.color.primary.withValues(alpha: isDark ? 0.7 : 0.1);
    }
  }

  Widget _buildButtonChild(BuildContext context) {
    switch (downloadState.status) {
      case QariDownloadStatus.completed:
        return Icon(
          Icons.download_done_rounded,
          color: Colors.green.shade600,
          size: 24.sp,
        );

      case QariDownloadStatus.inProgress:
        return SizedBox(
          width: 28.w,
          height: 28.w,
          child: Center(
            child: Text(
              '${downloadState.progressPercent}%',
              style: TextStyle(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                color: isDark ? context.color.onSurface : context.color.primary,
              ),
            ),
          ),
        );

      case QariDownloadStatus.error:
        return Icon(
          Icons.refresh_rounded,
          color: Colors.orange.shade600,
          size: 24.sp,
        );

      default:
        return Icon(
          Icons.download_rounded,
          color: isDark ? context.color.onSurface : context.color.primary,
          size: 24.sp,
        );
    }
  }

  Future<void> _handleDownloadTap(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(moratalDownloadProvider(params).notifier);

    switch (downloadState.status) {
      case QariDownloadStatus.completed:
        // لا شيء - التحميل مكتمل
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              content: Row(
                children: [
                  const Icon(
                    Icons.offline_pin_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'تم تحميل جميع السور. يمكنك الاستماع بدون إنترنت!',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        break;

      case QariDownloadStatus.inProgress:
        // عرض Dialog إلغاء التحميل
        final cancel = await _showCancelDialog(context);
        if (cancel == true) {
          notifier.cancelDownload();
          await WakelockPlus.disable();
        }
        break;

      case QariDownloadStatus.error:
        // استكمال التحميل
        final confirm = await _showConfirmDialog(context, isResume: true);
        if (confirm == true && context.mounted) {
          await WakelockPlus.enable();
          notifier.startDownloadAll().then((_) => WakelockPlus.disable());
        }
        break;

      default:
        // بدء تحميل جديد
        final confirm = await _showConfirmDialog(context, isResume: false);
        if (confirm == true && context.mounted) {
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
                color: Colors.orange.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.orange.withValues(alpha: .3)),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 18,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'هذه العملية قد تستهلك ما بين ٥٠٠ ميجابايت إلى ٢ جيجابايت من بيانات الإنترنت.',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12.sp,
                            color: Colors.orange.shade800,
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
                      const Icon(
                        Icons.phone_android_rounded,
                        color: Colors.orange,
                        size: 18,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'يرجى ترك التطبيق مفتوحاً حتى اكتمال التحميل. يمكنك الاستكمال في أي وقت إذا أُغلق التطبيق.',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12.sp,
                            color: Colors.orange.shade800,
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
            onPressed: () => Navigator.of(ctx).pop(true),
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
// زر الحذف
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
          color: isDark ? Colors.red.shade200 : Colors.red.shade600,
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
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              content: Text(
                'تم حذف جميع سور $qariName من الجهاز.',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            ),
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
