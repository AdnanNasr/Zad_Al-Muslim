import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qcf_quran/qcf_quran.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/utils/network/network_info.dart';
import 'package:zad_al_muslim/features/quran_moratal/data/services/moratal_download_service.dart';
import 'package:zad_al_muslim/features/quran_moratal/domain/entities/surah_meta_moratal_entity.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/providers/moratal_download_provider.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/providers/moratal_player_provider.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/providers/surahs_names_moratal_provider.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/widgets/internet_error_message.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/widgets/moratal_mini_player.dart';

class SelectQariSurahPage extends ConsumerStatefulWidget {
  final Map<String, String> qariData;
  const SelectQariSurahPage({super.key, required this.qariData});

  @override
  ConsumerState<SelectQariSurahPage> createState() =>
      _SelectQariSurahPageState();
}

class _SelectQariSurahPageState extends ConsumerState<SelectQariSurahPage> {
  final ScrollController _scrollController = ScrollController();

  String get _qariId => widget.qariData['id']!;
  String get _serverUrl => widget.qariData['server']!;
  String get _qariName => widget.qariData['name'] ?? '';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // منطق التشغيل: تحقق أولاً من الملف المحلي ثم الإنترنت
  // ---------------------------------------------------------------------------

  Future<void> _playSurah(SurahMetaMoratalEntity surah) async {
    // ١. التحقق من وجود الملف محلياً
    final downloadService = sl<MoratalDownloadService>();
    final isLocalAvailable = await downloadService.isSurahDownloaded(
      _qariId,
      surah.surahNumber,
    );

    final currentSurah = CurrentMoratalSurah(
      surahNumber: surah.surahNumber,
      surahName: surah.arabicName,
      qariName: _qariName,
      serverUrl: _serverUrl,
      qariId: _qariId,
    );

    if (isLocalAvailable) {
      // ✅ تشغيل من الجهاز مباشرة عبر المزود المشترك
      ref.read(playMoratalSurahActionProvider)(currentSurah);
      return;
    }

    // ٢. التحقق من الإنترنت
    final networkInfo = sl<NetworkInfo>();
    final hasInternet = await networkInfo.hasValidConnection();

    if (hasInternet) {
      // ✅ تشغيل من الإنترنت كالمعتاد عبر المزود المشترك
      ref.read(playMoratalSurahActionProvider)(currentSurah);
      return;
    }

    // ٣. لا ملف ولا إنترنت
    if (mounted) {
      InternetErrorMessage.showMessage(context: context);
    }
  }

  // ---------------------------------------------------------------------------
  // واجهة المستخدم
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final surahsMeta = ref.watch(surahsNamesMoratalProvider);
    final scheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // جلب حالة تحميل جميع السور دفعةً واحدة (I/O واحد متوازٍ بدلاً من 114 طلب)
    final allStatusAsync = ref.watch(allSurahsDownloadStatusProvider(_qariId));
    final allStatus = allStatusAsync.value ?? {};

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: SafeArea(
        child: Column(
          children: [
            _SurahPageHeader(qariName: _qariName),
            Expanded(
              child: Stack(
                children: [
                  AnimationLimiter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 4, top: 8.h),
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        trackVisibility: true,
                        interactive: true,
                        thickness: 5,
                        radius: const Radius.circular(24),
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.only(
                            left: 16.w,
                            right: 16.w,
                            bottom: 100.h,
                          ),
                          itemCount: surahsMeta.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 700),
                              child: SlideAnimation(
                                verticalOffset: 50,
                                child: FadeInAnimation(
                                  child: _buildSurahItem(
                                    context: context,
                                    surah: surahsMeta[index],
                                    isDark: isDark,
                                    isAlreadyDownloaded:
                                        allStatus[surahsMeta[index]
                                            .surahNumber] ??
                                        false,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
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

  Widget _buildSurahItem({
    required BuildContext context,
    required SurahMetaMoratalEntity surah,
    required bool isDark,
    required bool isAlreadyDownloaded,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Material(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(20.r),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: () => _playSurah(surah),
                child: Ink(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildNumberIndicator(
                        context: context,
                        number: surah.surahNumber,
                        isDark: isDark,
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'surah${surah.surahNumber.toString().padLeft(3, '0')}',
                              style: TextStyle(
                                fontFamily: 'surahname',
                                package: 'qcf_quran',
                                fontSize: 34.sp,
                                color: scheme.onSurface,
                              ),
                            ),
                            Text(
                              surah.englishName,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Cairo',
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 7.h),
                            Wrap(
                              spacing: 10.w,
                              runSpacing: 5.h,
                              children: [
                                _buildInfoChip(
                                  Icons.menu_book_rounded,
                                  surah.verseCount >= 10
                                      ? '${surah.verseCount} آية'
                                      : '${surah.verseCount} آيات',
                                  context,
                                ),
                                _buildInfoChip(
                                  Icons.grid_view_rounded,
                                  'الجزء ${surah.juzzNumber}',
                                  context,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 38.r,
                        height: 38.r,
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 24.sp,
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                      if (surah.surahNumber > 0)
                        _SurahOptionsMenu(
                          qariId: _qariId,
                          serverUrl: _serverUrl,
                          surahNumber: surah.surahNumber,
                          isDark: isDark,
                          initiallyDownloaded: isAlreadyDownloaded,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (surah.surahNumber > 0)
              PositionedDirectional(
                top: 9.h,
                end: 9.w,
                child: _SurahDownloadIndicator(
                  qariId: _qariId,
                  serverUrl: _serverUrl,
                  surahNumber: surah.surahNumber,
                  initiallyDownloaded: isAlreadyDownloaded,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberIndicator({
    required BuildContext context,
    required int number,
    required bool isDark,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 42.r,
      height: 42.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(
        number.toString(),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w800,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: scheme.primary),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5.sp,
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahPageHeader extends StatelessWidget {
  const _SurahPageHeader({required this.qariName});
  final String qariName;

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
              Icons.menu_book_rounded,
              color: scheme.onPrimaryContainer,
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سور القرآن الكريم',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  qariName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11.sp,
                    color: scheme.primary,
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

// ---------------------------------------------------------------------------
// قائمة خيارات السورة (٣ نقاط) - تحل محل زر التحميل
// ---------------------------------------------------------------------------

class _SurahOptionsMenu extends ConsumerStatefulWidget {
  final String qariId;
  final String serverUrl;
  final int surahNumber;
  final bool isDark;

  /// الحالة الأولية من allSurahsDownloadStatusProvider بدلاً من I/O فردي
  final bool initiallyDownloaded;

  const _SurahOptionsMenu({
    required this.qariId,
    required this.serverUrl,
    required this.surahNumber,
    required this.isDark,
    required this.initiallyDownloaded,
  });

  @override
  ConsumerState<_SurahOptionsMenu> createState() => _SurahOptionsMenuState();
}

class _SurahOptionsMenuState extends ConsumerState<_SurahOptionsMenu> {
  late ({String qariId, String serverUrl, int surahNumber}) _params;

  @override
  void initState() {
    super.initState();
    _params = (
      qariId: widget.qariId,
      serverUrl: widget.serverUrl,
      surahNumber: widget.surahNumber,
    );
    Future.microtask(() {
      if (mounted) {
        ref
            .read(singleSurahDownloadProvider(_params).notifier)
            .setInitialStatus(widget.initiallyDownloaded);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(singleSurahDownloadProvider(_params));

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        size: 22.sp,
        color: widget.isDark
            ? context.color.onSurface.withValues(alpha: 0.65)
            : context.color.onSurface.withValues(alpha: 0.55),
      ),
      padding: EdgeInsets.zero,
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      elevation: 4,
      onSelected: (value) => _handleMenuSelection(context, value, state),
      itemBuilder: (_) => _buildMenuItems(context, state),
    );
  }

  // ---------------------------------------------------------------------------
  // بناء عناصر القائمة بناءً على حالة التحميل
  // ---------------------------------------------------------------------------

  List<PopupMenuEntry<String>> _buildMenuItems(
    BuildContext context,
    SurahDownloadState state,
  ) {
    switch (state.status) {
      // الحالة ١: لم تُحمَّل بعد
      case SurahDownloadStatus.notDownloaded:
        return [
          _popupItem(
            value: 'download',
            icon: Icons.download_for_offline_rounded,
            label: 'تحميل السورة',
            color: context.color.primary,
            context: context,
          ),
        ];

      // الحالة ٢: تم تحميلها كاملاً
      case SurahDownloadStatus.downloaded:
        return [
          _popupItem(
            value: 'delete',
            icon: Icons.delete_outline_rounded,
            label: 'حذف السورة',
            color: context.color.error,
            context: context,
          ),
        ];

      // الحالة ٣: جارٍ التحميل الآن
      case SurahDownloadStatus.downloading:
        return [
          _popupItem(
            value: 'cancel',
            icon: Icons.cancel_outlined,
            label: 'إلغاء التحميل',
            color: context.color.error,
            context: context,
          ),
        ];
    }
  }

  PopupMenuItem<String> _popupItem({
    required String value,
    required IconData icon,
    required String label,
    required Color color,
    required BuildContext context,
  }) {
    return PopupMenuItem<String>(
      value: value,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: color),
          SizedBox(width: 10.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // معالجة اختيار المستخدم من القائمة
  // ---------------------------------------------------------------------------

  Future<void> _handleMenuSelection(
    BuildContext context,
    String value,
    SurahDownloadState state,
  ) async {
    final notifier = ref.read(singleSurahDownloadProvider(_params).notifier);

    switch (value) {
      // ─── تحميل السورة ────────────────────────────────────────────────────
      case 'download':
        final hasInternet = await NetworkInfo().hasValidConnection();
        if (!hasInternet) {
          if (!context.mounted) return;
          InternetErrorMessage.showMessage(context: context);
          return;
        }
        await WakelockPlus.enable();
        await notifier.startDownload();
        await WakelockPlus.disable();
        if (!context.mounted) return;
        final newState = ref.read(singleSurahDownloadProvider(_params));
        if (newState.status == SurahDownloadStatus.downloaded) {
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
                            .download_done, // نفس أيقونة التأكيد المتوفرة أوفلاين
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'تم تحميل سورة ${getSurahNameArabic(_params.surahNumber)} بنجاح',
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
        break;

      // ─── حذف السورة ──────────────────────────────────────────────────────
      case 'delete':
        final confirm = await _showDeleteDialog(context);
        if (confirm == true && context.mounted) {
          await notifier.delete();
          if (context.mounted) {
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
                              .delete_rounded, // نفس أيقونة التأكيد المتوفرة أوفلاين
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'تم حذف سورة ${getSurahNameArabic(_params.surahNumber)} من الجهاز',
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
        break;

      // ─── إلغاء وحذف ──────────────────────────────────────────────────────
      case 'cancel':
        await notifier.delete();
        if (context.mounted) {
          _showSnackBar(
            context,
            icon: Icons.cancel_outlined,
            message: 'تم إلغاء التحميل وحذف الملف المؤقت.',
            color: Colors.red.shade700,
          );
        }
        break;
    }
  }

  // ---------------------------------------------------------------------------
  // مساعد: عرض SnackBar موحَّد
  // ---------------------------------------------------------------------------

  void _showSnackBar(
    BuildContext context, {
    required IconData icon,
    required String message,
    required Color color,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  message,
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
  }

  // ---------------------------------------------------------------------------
  // Dialog تأكيد الحذف
  // ---------------------------------------------------------------------------

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        titlePadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
        contentPadding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
        actionsPadding: EdgeInsets.all(12.w),
        title: Row(
          children: [
            Icon(
              Icons.delete_outline_rounded,
              color: Colors.red.shade600,
              size: 22.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'حذف السورة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'هل تريد حذف هذه السورة من الجهاز؟\nلا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(fontFamily: 'Cairo', fontSize: 13.sp, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13.sp,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
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
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// مؤشر حالة التحميل (الزاوية العلوية للبطاقة)
// ---------------------------------------------------------------------------

class _SurahDownloadIndicator extends ConsumerStatefulWidget {
  final String qariId;
  final String serverUrl;
  final int surahNumber;
  final bool initiallyDownloaded;

  const _SurahDownloadIndicator({
    required this.qariId,
    required this.serverUrl,
    required this.surahNumber,
    required this.initiallyDownloaded,
  });

  @override
  ConsumerState<_SurahDownloadIndicator> createState() =>
      _SurahDownloadIndicatorState();
}

class _SurahDownloadIndicatorState
    extends ConsumerState<_SurahDownloadIndicator> {
  late ({String qariId, String serverUrl, int surahNumber}) _params;

  @override
  void initState() {
    super.initState();
    _params = (
      qariId: widget.qariId,
      serverUrl: widget.serverUrl,
      surahNumber: widget.surahNumber,
    );
    Future.microtask(() {
      if (mounted) {
        ref
            .read(singleSurahDownloadProvider(_params).notifier)
            .setInitialStatus(widget.initiallyDownloaded);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(singleSurahDownloadProvider(_params));

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (state.status) {
        SurahDownloadStatus.downloaded => Icon(
          Icons.offline_pin_rounded,
          key: const ValueKey('downloaded'),
          size: 18.sp,
          color: Colors.green,
        ),
        SurahDownloadStatus.downloading => SizedBox(
          key: const ValueKey('downloading'),
          width: 18.w,
          height: 18.w,
          child: CircularProgressIndicator(
            value: state.progress > 0 ? state.progress : null,
            strokeWidth: 2.5,
            color: context.color.primary,
          ),
        ),
        _ => const SizedBox.shrink(key: ValueKey('none')),
      },
    );
  }
}
