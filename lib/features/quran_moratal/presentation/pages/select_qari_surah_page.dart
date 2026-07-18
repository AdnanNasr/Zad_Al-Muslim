import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';
import 'package:zad_al_muslim/core/common/widgets/custom_app_bar.dart';
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
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            backgroundColor: Colors.red.shade700,
            content: Row(
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'لا يوجد اتصال بالإنترنت. حمّل السورة أولاً للاستماع بدون إنترنت.',
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
  }

  // ---------------------------------------------------------------------------
  // واجهة المستخدم
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final surahsMeta = ref.watch(surahsNamesMoratalProvider);
    final ThemeMode themeMode = ref.watch(themeProvider);
    final bool isDark = themeMode == ThemeMode.dark;

    // جلب حالة تحميل جميع السور دفعةً واحدة (I/O واحد متوازٍ بدلاً من 114 طلب)
    final allStatusAsync = ref.watch(allSurahsDownloadStatusProvider(_qariId));
    final allStatus = allStatusAsync.value ?? {};

    return Scaffold(
      appBar: CustomAppBar(
        title: 'سور القرآن - ${widget.qariData['name']}',
        center: true,
      ),
      body: Stack(
        children: [
          AnimationLimiter(
            child: Padding(
              padding: EdgeInsets.only(left: 4, top: 20.h),
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
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
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
                                allStatus[surahsMeta[index].surahNumber] ??
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
    );
  }

  Widget _buildSurahItem({
    required BuildContext context,
    required SurahMetaMoratalEntity surah,
    required bool isDark,
    required bool isAlreadyDownloaded,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: context.color.primary.withValues(alpha: .2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: () => _playSurah(surah),
              child: Padding(
                padding: EdgeInsets.all(12.dg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildNumberIndicator(
                      context: context,
                      number: surah.surahNumber,
                      isDark: isDark,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'surah${surah.surahNumber.toString().padLeft(3, '0')}',
                            style: TextStyle(
                              fontFamily: 'surahname',
                              package: 'qcf_quran',
                              fontSize: 38.sp,
                              color: context.color.onSurface.withValues(
                                alpha: .8,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                surah.englishName,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Naskh',
                                  color: context.color.onSurface.withValues(
                                    alpha: .7,
                                  ),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  _buildInfoChip(
                                    Icons.menu_book_rounded,
                                    surah.verseCount >= 10
                                        ? '${surah.verseCount} آية'
                                        : '${surah.verseCount} آيات',
                                    context,
                                  ),
                                  SizedBox(width: 12.w),
                                  _buildInfoChip(
                                    Icons.grid_view_rounded,
                                    'الجزء ${surah.juzzNumber}',
                                    context,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // أيقونة التشغيل
                    Icon(
                      Icons.play_circle_outline_rounded,
                      size: 32.sp,
                      color: context.color.primary.withValues(alpha: .8),
                    ),

                    // قائمة الخيارات (٣ نقاط)
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
        ),
            if (surah.surahNumber > 0)
              PositionedDirectional(
                top: 12.h,
                end: 12.w,
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
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: 0.8,
          child: Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              color: isDark
                  ? context.color.primary.withValues(alpha: .8)
                  : context.color.primary.withValues(alpha: .25),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        Text(
          number.toString(),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? context.color.onSurface : context.color.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13.sp, color: context.color.primary),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5.sp,
            color: context.color.onSurface,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ],
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
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
            color: Colors.red.shade600,
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
            color: Colors.red.shade600,
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
          _showSnackBar(
            context,
            icon: Icons.check_circle_outline_rounded,
            message: 'تم تحميل السورة بنجاح ✅',
            color: Colors.green.shade700,
          );
        }
        break;

      // ─── حذف السورة ──────────────────────────────────────────────────────
      case 'delete':
        final confirm = await _showDeleteDialog(context);
        if (confirm == true && context.mounted) {
          await notifier.delete();
          if (context.mounted) {
            _showSnackBar(
              context,
              icon: Icons.delete_outline_rounded,
              message: 'تم حذف السورة من الجهاز.',
              color: Colors.red.shade700,
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
