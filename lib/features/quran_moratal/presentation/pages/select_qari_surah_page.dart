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
            duration: const Duration(milliseconds: 900),
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
    final allStatus = allStatusAsync.valueOrNull ?? {};

    return Scaffold(
      appBar: CustomAppBar(
        title: 'سور القرآن - ${widget.qariData['name']}',
        center: true,
        themeMode: false,
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
                                allStatus[surahsMeta[index].surahNumber] ?? false,
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

                    SizedBox(width: 8.w),

                    // زر تحميل السورة الفردي
                    if (surah.surahNumber > 0)
                      _SurahDownloadButton(
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
// زر تحميل سورة واحدة
// ---------------------------------------------------------------------------

class _SurahDownloadButton extends ConsumerStatefulWidget {
  final String qariId;
  final String serverUrl;
  final int surahNumber;
  final bool isDark;
  /// حالة التحميل الأولية من allSurahsDownloadStatusProvider بدلاً
  /// من استدعاء initialize() فردياً
  final bool initiallyDownloaded;

  const _SurahDownloadButton({
    required this.qariId,
    required this.serverUrl,
    required this.surahNumber,
    required this.isDark,
    required this.initiallyDownloaded,
  });

  @override
  ConsumerState<_SurahDownloadButton> createState() =>
      _SurahDownloadButtonState();
}

class _SurahDownloadButtonState extends ConsumerState<_SurahDownloadButton> {
  late ({String qariId, String serverUrl, int surahNumber}) _params;

  @override
  void initState() {
    super.initState();
    _params = (
      qariId: widget.qariId,
      serverUrl: widget.serverUrl,
      surahNumber: widget.surahNumber,
    );
    // إذا كانت الحالة الأولية محدّدة من allSurahsDownloadStatusProvider
    // نستخدم setInitialStatus مباشرةً دون I/O إضافي
    Future.microtask(() {
      if (mounted) {
        ref
            .read(singleSurahDownloadProvider(_params).notifier)
            .setInitialStatus(widget.initiallyDownloaded);
      }
    });
    // لا نستدعي initialize() بعد الآن لأن الحالة تأتي من الأعلى
  }

  @override
  Widget build(BuildContext context) {
    final surahDownloadState = ref.watch(singleSurahDownloadProvider(_params));

    return GestureDetector(
      onTap: () => _handleTap(context, surahDownloadState),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getColor(context, surahDownloadState.status),
        ),
        child: Center(child: _buildIcon(context, surahDownloadState)),
      ),
    );
  }

  Color _getColor(BuildContext context, SurahDownloadStatus status) {
    switch (status) {
      case SurahDownloadStatus.downloaded:
        return Colors.green.withValues(alpha: widget.isDark ? 0.7 : 0.15);
      case SurahDownloadStatus.downloading:
        return context.color.primary.withValues(alpha: 0.1);
      default:
        return context.color.primary.withValues(
          alpha: widget.isDark ? 0.6 : 0.08,
        );
    }
  }

  Widget _buildIcon(BuildContext context, SurahDownloadState state) {
    switch (state.status) {
      case SurahDownloadStatus.downloaded:
        return Icon(
          Icons.download_done_rounded,
          color: Colors.green.shade600,
          size: 16.sp,
        );
      case SurahDownloadStatus.downloading:
        return SizedBox(
          width: 16.w,
          height: 16.w,
          child: CircularProgressIndicator(
            value: state.progress > 0 ? state.progress : null,
            strokeWidth: 2,
            color: context.color.primary,
          ),
        );
      default:
        return Icon(
          Icons.download_rounded,
          color: widget.isDark
              ? context.color.onSurface.withValues(alpha: 0.7)
              : context.color.primary,
          size: 16.sp,
        );
    }
  }

  Future<void> _handleTap(
    BuildContext context,
    SurahDownloadState state,
  ) async {
    final notifier = ref.read(singleSurahDownloadProvider(_params).notifier);

    if (state.status == SurahDownloadStatus.downloaded) {
      // حذف السورة
      final confirm = await _showDeleteDialog(context);
      if (confirm == true) {
        await notifier.delete();
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
                  'تم حذف السورة من الجهاز.',
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
      return;
    }

    if (state.status == SurahDownloadStatus.downloading) return;

    final hasInternet = await NetworkInfo().hasValidConnection();

    if (!hasInternet) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 900), // TODO
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          backgroundColor: Colors.red.shade700,
          content: Row(
            children: [
              const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'يرجى التحقق من إتصالك بالإنترنت.',
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

    // بدء التحميل
    await WakelockPlus.enable();
    await notifier.startDownload();
    await WakelockPlus.disable();

    if (context.mounted && state.status != SurahDownloadStatus.downloaded) {
      final newState = ref.read(singleSurahDownloadProvider(_params));
      if (newState.status == SurahDownloadStatus.downloaded) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              content: Text(
                'تم تحميل السورة بنجاح ✅',
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

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'حذف السورة',
          style: TextStyle(fontFamily: 'Cairo', fontSize: 15.sp),
        ),
        content: Text(
          'هل تريد حذف هذه السورة من الجهاز؟',
          style: TextStyle(fontFamily: 'Cairo', fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'إلغاء',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 13.sp),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            child: Text(
              'حذف',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }
}
