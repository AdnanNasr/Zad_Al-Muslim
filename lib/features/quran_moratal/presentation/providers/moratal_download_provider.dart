import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/features/quran_moratal/data/services/moratal_download_service.dart';

// ---------------------------------------------------------------------------
// حالات التحميل
// ---------------------------------------------------------------------------

enum QariDownloadStatus {
  /// لم يُحمَّل بعد
  notDownloaded,

  /// جاري التحميل
  inProgress,

  /// اكتمل التحميل بنجاح
  completed,

  /// حدث خطأ أثناء التحميل
  error,

  /// جاري تحميل سورة واحدة (وليس الكل)
  singleInProgress,
}

// ---------------------------------------------------------------------------
// حالة التحميل لقارئ
// ---------------------------------------------------------------------------

class QariDownloadState {
  final QariDownloadStatus status;
  final int downloadedCount;
  final int totalCount;
  final double overallProgress;
  final int currentSurah;
  final String? errorMessage;

  const QariDownloadState({
    required this.status,
    this.downloadedCount = 0,
    this.totalCount = 114,
    this.overallProgress = 0.0,
    this.currentSurah = 0,
    this.errorMessage,
  });

  /// نسبة مئوية من 0 إلى 100
  int get progressPercent => (overallProgress * 100).toInt();

  QariDownloadState copyWith({
    QariDownloadStatus? status,
    int? downloadedCount,
    int? totalCount,
    double? overallProgress,
    int? currentSurah,
    String? errorMessage,
  }) {
    return QariDownloadState(
      status: status ?? this.status,
      downloadedCount: downloadedCount ?? this.downloadedCount,
      totalCount: totalCount ?? this.totalCount,
      overallProgress: overallProgress ?? this.overallProgress,
      currentSurah: currentSurah ?? this.currentSurah,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ---------------------------------------------------------------------------
// حالة التحميل لسورة واحدة
// ---------------------------------------------------------------------------

enum SurahDownloadStatus { notDownloaded, downloading, downloaded }

class SurahDownloadState {
  final SurahDownloadStatus status;
  final double progress;

  const SurahDownloadState({
    required this.status,
    this.progress = 0.0,
  });
}

// ---------------------------------------------------------------------------
// Notifier للقارئ (يدير تحميل الكل أو جزء)
// ---------------------------------------------------------------------------

class MoratalDownloadNotifier
    extends StateNotifier<QariDownloadState> {
  final String _qariId;
  final String _serverUrl;

  MoratalDownloadNotifier(
    this._qariId,
    this._serverUrl,
  ) : super(const QariDownloadState(status: QariDownloadStatus.notDownloaded));

  MoratalDownloadService get _service => sl<MoratalDownloadService>();

  /// تهيئة الحالة الأولية بالتحقق من الملفات المُحمَّلة مسبقاً
  Future<void> initialize() async {
    // إذا كان التحميل جارياً بالفعل في الخلفية، أعد ربط المستمع واسترجاع التقدم
    if (_service.isDownloading(_qariId)) {
      _service.updateCallbacks(
        qariId: _qariId,
        onProgress: ({
          required downloadedCount,
          required totalCount,
          required overallProgress,
          required currentSurah,
        }) {
          if (mounted) {
            final isDone = downloadedCount == totalCount;
            state = state.copyWith(
              status: isDone ? QariDownloadStatus.completed : QariDownloadStatus.inProgress,
              downloadedCount: downloadedCount,
              totalCount: totalCount,
              overallProgress: overallProgress,
              currentSurah: currentSurah,
            );
            if (isDone) {
              _showGlobalCompletionSnackBar();
            }
          }
        },
        onError: (errorMessage) {
          if (mounted) {
            state = state.copyWith(
              status: QariDownloadStatus.error,
              errorMessage: errorMessage,
            );
          }
        },
      );

      final currentProgress = _service.getCurrentProgress(_qariId);
      if (currentProgress != null && mounted) {
        final isDone = currentProgress.downloadedCount == currentProgress.totalCount;
        state = QariDownloadState(
          status: isDone ? QariDownloadStatus.completed : QariDownloadStatus.inProgress,
          downloadedCount: currentProgress.downloadedCount,
          totalCount: currentProgress.totalCount,
          overallProgress: currentProgress.overallProgress,
          currentSurah: currentProgress.currentSurah,
        );
        if (isDone && mounted) {
          _showGlobalCompletionSnackBar();
        }
      } else if (mounted) {
        // حالة مؤقتة للتحميل قبل أول تحديث للتقدم من Dio
        state = const QariDownloadState(
          status: QariDownloadStatus.inProgress,
          downloadedCount: 0,
          totalCount: 114,
          overallProgress: 0.0,
        );
      }
      return;
    }

    if (state.status == QariDownloadStatus.inProgress) {
      return;
    }

    final downloadedCount = await _service.getDownloadedSurahCount(_qariId);
    if (downloadedCount == 114) {
      if (mounted) {
        state = const QariDownloadState(
          status: QariDownloadStatus.completed,
          downloadedCount: 114,
          totalCount: 114,
          overallProgress: 1.0,
        );
      }
    } else if (downloadedCount > 0) {
      // تم تحميل جزء منها - أظهر أنه جاهز للاستكمال
      if (mounted) {
        state = QariDownloadState(
          status: QariDownloadStatus.error,
          downloadedCount: downloadedCount,
          totalCount: 114,
          overallProgress: downloadedCount / 114,
          errorMessage: 'تم تحميل $downloadedCount من 114 سورة. اضغط للاستكمال.',
        );
      }
    } else {
      if (mounted) {
        state = const QariDownloadState(
          status: QariDownloadStatus.notDownloaded,
        );
      }
    }
  }

  /// بدء أو استكمال تحميل جميع السور
  Future<void> startDownloadAll() async {
    if (state.status == QariDownloadStatus.inProgress) return;

    state = QariDownloadState(
      status: QariDownloadStatus.inProgress,
      downloadedCount: state.downloadedCount,
      totalCount: 114,
      overallProgress: state.overallProgress,
    );

    final success = await _service.downloadAllSurahs(
      qariId: _qariId,
      serverUrl: _serverUrl,
      onProgress: ({
        required downloadedCount,
        required totalCount,
        required overallProgress,
        required currentSurah,
      }) {
        if (mounted) {
          final isDone = downloadedCount == totalCount;
          state = state.copyWith(
            status: isDone ? QariDownloadStatus.completed : QariDownloadStatus.inProgress,
            downloadedCount: downloadedCount,
            totalCount: totalCount,
            overallProgress: overallProgress,
            currentSurah: currentSurah,
          );
          if (isDone) {
            _showGlobalCompletionSnackBar();
          }
        }
      },
      onError: (errorMessage) {
        if (mounted) {
          state = state.copyWith(
            status: QariDownloadStatus.error,
            errorMessage: errorMessage,
          );
        }
      },
    );

    if (!mounted) return;

    if (success) {
      state = const QariDownloadState(
        status: QariDownloadStatus.completed,
        downloadedCount: 114,
        totalCount: 114,
        overallProgress: 1.0,
      );

      // إشعار عالمي باكتمال التحميل
      _showGlobalCompletionSnackBar();
    }
  }

  /// إلغاء عملية التحميل
  void cancelDownload() {
    _service.cancelDownload(_qariId);
    if (mounted) {
      final downloaded = state.downloadedCount;
      state = QariDownloadState(
        status: downloaded > 0
            ? QariDownloadStatus.error
            : QariDownloadStatus.notDownloaded,
        downloadedCount: downloaded,
        totalCount: 114,
        overallProgress: state.overallProgress,
        errorMessage: downloaded > 0
            ? 'تم إيقاف التحميل. تم حفظ $downloaded سورة.'
            : null,
      );
    }
  }

  /// حذف جميع سور القارئ
  Future<void> deleteAllDownloads() async {
    _service.cancelDownload(_qariId);
    await _service.deleteAllQariSurahs(_qariId);
    if (mounted) {
      state = const QariDownloadState(
        status: QariDownloadStatus.notDownloaded,
      );
    }
  }

  void _showGlobalCompletionSnackBar() {
    // يتم استدعاؤه من خارج الـ Provider عبر global key
    moratalDownloadCompletedCallback?.call(_qariId);
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

/// Provider رئيسي لحالة تحميل كل قارئ
/// المفتاح: ({qariId, serverUrl})
final moratalDownloadProvider = StateNotifierProvider.family<
    MoratalDownloadNotifier,
    QariDownloadState,
    ({String qariId, String serverUrl})>(
  (ref, params) => MoratalDownloadNotifier(
    params.qariId,
    params.serverUrl,
  ),
);

/// Provider للتحقق من حالة سورة واحدة
final surahLocalStatusProvider = FutureProvider.family<
    SurahDownloadState,
    ({String qariId, int surahNumber})>(
  (ref, params) async {
    final service = sl<MoratalDownloadService>();
    final isDownloaded =
        await service.isSurahDownloaded(params.qariId, params.surahNumber);
    return SurahDownloadState(
      status: isDownloaded
          ? SurahDownloadStatus.downloaded
          : SurahDownloadStatus.notDownloaded,
    );
  },
);

/// Provider لحساب حجم الملفات المُحمَّلة لقارئ
final qariDownloadedSizeMBProvider =
    FutureProvider.family<double, String>((ref, qariId) async {
  final service = sl<MoratalDownloadService>();
  return service.getDownloadedSizeMB(qariId);
});

// ---------------------------------------------------------------------------
// Callback عالمي لإشعار المستخدم باكتمال التحميل من أي صفحة
// ---------------------------------------------------------------------------

/// يتم تعيينه من app_root.dart أو main.dart
void Function(String qariId)? moratalDownloadCompletedCallback;

/// Provider لحالة تحميل سورة واحدة (أثناء التحميل)
/// المفتاح: ({qariId, serverUrl, surahNumber})
final singleSurahDownloadProvider = StateNotifierProvider.family<
    SingleSurahDownloadNotifier,
    SurahDownloadState,
    ({String qariId, String serverUrl, int surahNumber})>(
  (ref, params) => SingleSurahDownloadNotifier(
    params.qariId,
    params.serverUrl,
    params.surahNumber,
  ),
);

class SingleSurahDownloadNotifier extends StateNotifier<SurahDownloadState> {
  final String _qariId;
  final String _serverUrl;
  final int _surahNumber;

  // Throttle: نمنع الـ rebuild إلا عند تغيّر النسبة المئوية
  // مثلما يفعل MoratalDownloadNotifier في downloadAllSurahs
  int _lastProgressPercent = -1;

  SingleSurahDownloadNotifier(
    this._qariId,
    this._serverUrl,
    this._surahNumber,
  ) : super(const SurahDownloadState(status: SurahDownloadStatus.notDownloaded));

  MoratalDownloadService get _service => sl<MoratalDownloadService>();

  Future<void> initialize() async {
    final isDownloaded =
        await _service.isSurahDownloaded(_qariId, _surahNumber);
    if (mounted) {
      state = SurahDownloadState(
        status: isDownloaded
            ? SurahDownloadStatus.downloaded
            : SurahDownloadStatus.notDownloaded,
      );
    }
  }

  /// تعيين الحالة الأولية مباشرةً دون I/O إضافي
  /// يُستخدم عندما تكون الحالة معروفة مسبقاً من allSurahsDownloadStatusProvider
  void setInitialStatus(bool isDownloaded) {
    if (mounted && state.status == SurahDownloadStatus.notDownloaded) {
      state = SurahDownloadState(
        status: isDownloaded
            ? SurahDownloadStatus.downloaded
            : SurahDownloadStatus.notDownloaded,
      );
    }
  }

  Future<void> startDownload() async {
    if (state.status == SurahDownloadStatus.downloading) return;
    _lastProgressPercent = -1;
    if (mounted) {
      state = const SurahDownloadState(
        status: SurahDownloadStatus.downloading,
        progress: 0.0,
      );
    }

    final success = await _service.downloadSingleSurah(
      qariId: _qariId,
      serverUrl: _serverUrl,
      surahNumber: _surahNumber,
      onProgress: (progress) {
        if (mounted) {
          // Throttle: نُحدّث الـ state فقط عند تغيّر النسبة المئوية
          // هذا يُقلل عمليات الـ rebuild من آلاف المرات إلى 100 مرة كحد أقصى
          final percent = (progress * 100).toInt();
          if (percent != _lastProgressPercent) {
            _lastProgressPercent = percent;
            state = SurahDownloadState(
              status: SurahDownloadStatus.downloading,
              progress: progress,
            );
          }
        }
      },
    );

    if (mounted) {
      state = SurahDownloadState(
        status: success
            ? SurahDownloadStatus.downloaded
            : SurahDownloadStatus.notDownloaded,
      );
    }
  }

  Future<void> delete() async {
    await _service.deleteSurah(_qariId, _surahNumber);
    if (mounted) {
      state = const SurahDownloadState(
        status: SurahDownloadStatus.notDownloaded,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Provider لجلب حالة جميع السور دفعةً واحدة (بدلاً من 114 I/O منفصل)
// ---------------------------------------------------------------------------

/// يُحضر حالة تحميل جميع السور لقارئ معين في طلب I/O واحد متوازٍ
/// الـ key: qariId
/// النتيجة: Map of surahNumber to isDownloaded
final allSurahsDownloadStatusProvider =
    FutureProvider.family<Map<int, bool>, String>((ref, qariId) async {
  final service = sl<MoratalDownloadService>();
  // تنفيذ 114 فحص بشكل متوازٍ (Future.wait) بدلاً من متسلسل
  final results = await Future.wait(
    List.generate(114, (i) => service.isSurahDownloaded(qariId, i + 1)),
  );
  return {for (int i = 0; i < 114; i++) i + 1: results[i]};
});
