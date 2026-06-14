import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';

/// معلومات تقدم التحميل
class DownloadProgressInfo {
  final int downloadedCount;
  final int totalCount;
  final double overallProgress;
  final int currentSurah;

  DownloadProgressInfo({
    required this.downloadedCount,
    required this.totalCount,
    required this.overallProgress,
    required this.currentSurah,
  });
}

/// خدمة تحميل ملفات الصوت للقرآن المرتل
/// تدعم:
/// - تحميل سورة واحدة أو جميع السور
/// - الاستكمال من نفس نقطة التوقف
/// - حذف الملفات التالفة تلقائياً
/// - إلغاء التحميل في أي وقت
class MoratalDownloadService {
  final SharedPreferences _prefs;
  final Dio _dio;

  // مفتاح SharedPreferences لتخزين آخر سورة تم تحميلها بنجاح لكل قارئ
  static const String _lastDownloadedKey = 'moratal_last_downloaded_';

  // CancelToken للتحكم في إلغاء التحميل
  final Map<String, CancelToken> _cancelTokens = {};

  // مسار الحفظ الأساسي: {appDocumentsDir}/moratal/{qariId}/{surahNumber}.mp3
  static const String _baseFolder = 'moratal';

  // تتبع التقدم الفعلي والـ callbacks لكل قارئ
  final Map<String, DownloadProgressInfo> _currentProgress = {};
  final Map<
    String,
    void Function({
      required int downloadedCount,
      required int totalCount,
      required double overallProgress,
      required int currentSurah,
    })
  >
  _progressCallbacks = {};
  final Map<String, void Function(String errorMessage)?> _errorCallbacks = {};

  bool isDownloading(String qariId) {
    return _cancelTokens.containsKey(qariId) &&
        !(_cancelTokens[qariId]?.isCancelled ?? true);
  }

  DownloadProgressInfo? getCurrentProgress(String qariId) {
    return _currentProgress[qariId];
  }

  void updateCallbacks({
    required String qariId,
    required void Function({
      required int downloadedCount,
      required int totalCount,
      required double overallProgress,
      required int currentSurah,
    })
    onProgress,
    required void Function(String errorMessage)? onError,
  }) {
    _progressCallbacks[qariId] = onProgress;
    _errorCallbacks[qariId] = onError;
  }

  MoratalDownloadService({required SharedPreferences prefs, Dio? dio})
    : _prefs = prefs,
      _dio = dio ?? Dio();

  // ---------------------------------------------------------------------------
  // مسارات الملفات
  // ---------------------------------------------------------------------------

  /// يبني مسار مجلد القارئ على جهاز المستخدم
  Future<String> getQariFolderPath(String qariId) async {
    final appDir = await getApplicationDocumentsDirectory();
    return '${appDir.path}/$_baseFolder/$qariId';
  }

  /// يبني مسار ملف السورة على جهاز المستخدم
  Future<String> getSurahLocalPath(String qariId, int surahNumber) async {
    final folder = await getQariFolderPath(qariId);
    final paddedNumber = surahNumber.toString().padLeft(3, '0');
    return '$folder/$paddedNumber.mp3';
  }

  // ---------------------------------------------------------------------------
  // التحقق من حالة التحميل
  // ---------------------------------------------------------------------------

  /// التحقق من أن سورة معينة قد تم تحميلها بنجاح
  Future<bool> isSurahDownloaded(String qariId, int surahNumber) async {
    final path = await getSurahLocalPath(qariId, surahNumber);
    final file = File(path);
    if (!await file.exists()) return false;
    // تحقق أن الملف ليس فارغاً أو تالفاً
    final size = await file.length();
    return size > 1024; // على الأقل 1KB لضمان أنه ملف صوتي حقيقي
  }

  /// يحصل على عدد السور المُحمَّلة لقارئ معين
  Future<int> getDownloadedSurahCount(String qariId) async {
    int count = 0;
    for (int i = 1; i <= 114; i++) {
      if (await isSurahDownloaded(qariId, i)) count++;
    }
    return count;
  }

  /// التحقق من أن جميع السور تم تحميلها
  Future<bool> areAllSurahsDownloaded(String qariId) async {
    for (int i = 1; i <= 114; i++) {
      if (!await isSurahDownloaded(qariId, i)) return false;
    }
    return true;
  }

  // ---------------------------------------------------------------------------
  // آخر سورة تم تحميلها (للاستكمال من نقطة التوقف)
  // ---------------------------------------------------------------------------

  Future<void> _saveLastDownloadedSurah(String qariId, int surahNumber) async {
    await _prefs.setInt('$_lastDownloadedKey$qariId', surahNumber);
  }

  Future<void> _clearLastDownloadedSurah(String qariId) async {
    await _prefs.remove('$_lastDownloadedKey$qariId');
  }

  // ---------------------------------------------------------------------------
  // تحميل سورة واحدة
  // ---------------------------------------------------------------------------

  /// تحميل سورة واحدة محددة
  /// يعيد: true إذا نجح التحميل، false إذا فشل
  Future<bool> downloadSingleSurah({
    required String qariId,
    required String serverUrl,
    required int surahNumber,
    void Function(double progress)? onProgress,
    CancelToken? cancelToken,
    void Function()? onConnectionError,
  }) async {
    final localPath = await getSurahLocalPath(qariId, surahNumber);
    final tempPath = '$localPath.temp';
    final file = File(localPath);
    final tempFile = File(tempPath);
    final dir = file.parent;

    // إنشاء المجلد إذا لم يكن موجوداً
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    // بناء رابط الملف على الخادم
    final paddedNumber = surahNumber.toString().padLeft(3, '0');
    final remoteUrl = '$serverUrl$paddedNumber.mp3';

    AppLogger.logger.i('بدء تحميل السورة $surahNumber من: $remoteUrl');

    try {
      // إذا كان الملف النهائي موجوداً مسبقاً وصحيحاً، لا حاجة لإعادة التحميل
      if (await isSurahDownloaded(qariId, surahNumber)) {
        onProgress?.call(1.0);
        return true;
      }

      // حذف أي ملف مؤقت غير مكتمل قبل البدء
      if (await tempFile.exists()) {
        await tempFile.delete();
        AppLogger.logger.w('حذف ملف مؤقت تالف للسورة $surahNumber');
      }

      await _dio.download(
        remoteUrl,
        tempPath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            onProgress?.call(received / total);
          }
        },
        options: Options(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          headers: {'Accept': '*/*', 'Connection': 'keep-alive'},
        ),
      );

      // التحقق من اكتمال الملف بعد التحميل ونقله إلى المسار النهائي
      if (await tempFile.exists()) {
        final size = await tempFile.length();
        if (size > 1024) {
          if (await file.exists()) {
            await file.delete();
          }
          await tempFile.rename(localPath);
          AppLogger.logger.i('✅ تم تحميل السورة $surahNumber بنجاح');
          onProgress?.call(1.0);
          return true;
        } else {
          await tempFile.delete();
          AppLogger.logger.e(
            'حذف ملف مؤقت تالف للسورة $surahNumber بعد التحميل',
          );
          return false;
        }
      }
      return false;
    } on DioException catch (e) {
      // حذف الملف المؤقت في حالة أي خطأ في التحميل
      if (await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }

      if (e.type == DioExceptionType.cancel) {
        AppLogger.logger.i('تم إلغاء تحميل السورة $surahNumber');
        return false;
      }

      // التحقق مما إذا كان الخطأ شبكياً
      final isNetworkError =
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError;

      if (isNetworkError && onConnectionError != null) {
        onConnectionError();
      }

      final errorDetail =
          e.message ??
          e.error?.toString() ??
          e.response?.statusMessage ??
          e.type.toString();
      AppLogger.logger.e('خطأ في تحميل السورة $surahNumber: $errorDetail');
      return false;
    } catch (e) {
      // حذف الملف المؤقت عند أي خطأ آخر
      if (await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
      AppLogger.logger.e('خطأ غير متوقع في تحميل السورة $surahNumber: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // تحميل جميع السور
  // ---------------------------------------------------------------------------

  /// تحميل جميع سور القرآن لقارئ معين مع دعم الاستكمال من نقطة التوقف
  /// [onProgress]: callback يُستدعى عند تحديث تقدم التحميل
  /// [onSurahCompleted]: callback يُستدعى عند اكتمال كل سورة
  /// [onError]: callback عند حدوث خطأ
  /// يعيد: true إذا اكتمل التحميل، false إذا تم الإلغاء أو حدث خطأ
  /// تحميل جميع سور القرآن لقارئ معين مع دعم التحميل المتوازي (بحد أقصى ٣ سور معاً)
  /// [onProgress]: callback يُستدعى عند تحديث تقدم التحميل
  /// [onSurahCompleted]: callback يُستدعى عند اكتمال كل سورة
  /// [onError]: callback عند حدوث خطأ
  /// يعيد: true إذا اكتمل التحميل، false إذا تم الإلغاء أو حدث خطأ
  Future<bool> downloadAllSurahs({
    required String qariId,
    required String serverUrl,
    required void Function({
      required int downloadedCount,
      required int totalCount,
      required double overallProgress,
      required int currentSurah,
    })
    onProgress,
    void Function(int surahNumber)? onSurahCompleted,
    void Function(String errorMessage)? onError,
  }) async {
    const totalSurahs = 114;

    // تسجيل الـ callbacks في الخدمة لتمكين الـ Provider الجديد من الاستماع إليها
    updateCallbacks(qariId: qariId, onProgress: onProgress, onError: onError);

    // إنشاء CancelToken لهذا القارئ
    final cancelToken = CancelToken();
    _cancelTokens[qariId] = cancelToken;

    // تحديد قائمة السور المتبقية للتحميل وحساب السور المحملة مسبقاً
    final remainingSurahs = <int>[];
    final progressMap = <int, double>{};

    for (int i = 1; i <= totalSurahs; i++) {
      if (await isSurahDownloaded(qariId, i)) {
        progressMap[i] = 1.0;
      } else {
        remainingSurahs.add(i);
        progressMap[i] = 0.0;
      }
    }

    if (remainingSurahs.isEmpty) {
      _cancelTokens.remove(qariId);
      _progressCallbacks.remove(qariId);
      _errorCallbacks.remove(qariId);
      return true;
    }

    AppLogger.logger.i(
      'بدء تحميل جميع سور قارئ $qariId بشكل متوازٍ (المتبقي: ${remainingSurahs.length} من $totalSurahs)',
    );

    int lastPercent = -1;
    int lastCompletedCount = -1;

    void updateProgress(int surahNumber, double progress) {
      // فقط نقوم بتحديث التقدم إذا كان التقدم الجديد أكبر من التقدم الحالي للملف
      // أو إذا تم تحديد التقدم بـ 1.0 (اكتمال)
      // ولا نقبل التراجع إلى قيم أقل لمنع تراجع شريط التقدم
      final currentProgress = progressMap[surahNumber] ?? 0.0;
      if (progress > currentProgress || progress == 1.0) {
        progressMap[surahNumber] = progress;
      }

      // حساب عدد السور المكتملة بناءً على عدد العناصر ذات التقدم 1.0 في الخريطة
      final completedCount = progressMap.values
          .where((val) => val == 1.0)
          .length;

      final totalProgressSum = progressMap.values.fold(
        0.0,
        (sum, val) => sum + val,
      );
      final overallProgress = totalProgressSum / totalSurahs;
      final percent = (overallProgress * 100).toInt();

      // تخزين حالة التقدم الحالية في الخدمة لاسترجاعها عند إعادة إنشاء الـ Notifier
      _currentProgress[qariId] = DownloadProgressInfo(
        downloadedCount: completedCount,
        totalCount: totalSurahs,
        overallProgress: overallProgress,
        currentSurah: surahNumber,
      );

      // تجنب إعادة بناء الواجهة (Rebuild) آلاف المرات في الثانية:
      // نقوم بإرسال التحديث فقط عند تغير النسبة المئوية أو اكتمال سورة جديدة
      if (percent != lastPercent || completedCount != lastCompletedCount) {
        lastPercent = percent;
        lastCompletedCount = completedCount;
        final currentProgressCallback = _progressCallbacks[qariId];
        if (currentProgressCallback != null) {
          currentProgressCallback(
            downloadedCount: completedCount,
            totalCount: totalSurahs,
            overallProgress: overallProgress,
            currentSurah: surahNumber,
          );
        }
      }
    }

    // إرسال التحديث الأولي للبداية
    updateProgress(remainingSurahs.first, 0.0);

    int nextIndex = 0;
    final failedSurahs = <int>[];
    int consecutiveConnectionErrors = 0;

    // دالة العامل (Worker) لتحميل السور واحدة تلو الأخرى من القائمة المشتركة
    Future<void> downloadWorker() async {
      while (!cancelToken.isCancelled) {
        int currentSurahNumber;
        if (nextIndex >= remainingSurahs.length) {
          break;
        }
        currentSurahNumber = remainingSurahs[nextIndex++];

        try {
          final success = await downloadSingleSurah(
            qariId: qariId,
            serverUrl: serverUrl,
            surahNumber: currentSurahNumber,
            cancelToken: cancelToken,
            onProgress: (progress) {
              updateProgress(currentSurahNumber, progress);
            },
            onConnectionError: () {
              consecutiveConnectionErrors++;
              if (consecutiveConnectionErrors >= 3) {
                if (!cancelToken.isCancelled) {
                  cancelToken.cancel('network_error');
                }
              }
            },
          );

          if (cancelToken.isCancelled) return;

          if (success) {
            consecutiveConnectionErrors = 0;
            await _saveLastDownloadedSurah(qariId, currentSurahNumber);
            onSurahCompleted?.call(currentSurahNumber);
            updateProgress(currentSurahNumber, 1.0);
          } else {
            failedSurahs.add(currentSurahNumber);
          }
        } catch (e) {
          failedSurahs.add(currentSurahNumber);
        }
      }
    }

    // تشغيل 3 عمال تحميل متوازيين كحد أقصى (Max Concurrent Downloads = 3)
    final concurrencyLimit = remainingSurahs.length < 3
        ? remainingSurahs.length
        : 3;
    final workers = List.generate(concurrencyLimit, (_) => downloadWorker());

    await Future.wait(workers);

    _cancelTokens.remove(qariId);
    _progressCallbacks.remove(qariId);
    final errorCallback = _errorCallbacks.remove(qariId);
    _currentProgress.remove(qariId);

    if (cancelToken.isCancelled) {
      AppLogger.logger.i('تم إلغاء تحميل السور للقارئ $qariId');
      final isNetworkCancel =
          cancelToken.cancelError?.error == 'network_error' ||
          cancelToken.cancelError?.message == 'network_error';
      if (isNetworkCancel && errorCallback != null) {
        errorCallback(
          'انقطع الاتصال بالخادم. يرجى التحقق من الاتصال بالإنترنت وإعادة المحاولة.',
        );
      }
      return false;
    }

    if (failedSurahs.isNotEmpty) {
      final errorMessage =
          'فشل تحميل ${failedSurahs.length} سورة. يرجى المحاولة مرة أخرى للاستكمال.';
      AppLogger.logger.e(errorMessage);
      if (errorCallback != null) {
        errorCallback(errorMessage);
      }
      return false;
    }

    // اكتمل التحميل بنجاح - مسح سجل الاستكمال
    await _clearLastDownloadedSurah(qariId);
    AppLogger.logger.i(
      '✅ تم تحميل جميع سور القارئ $qariId بنجاح وبشكل متوازٍ!',
    );
    return true;
  }

  // ---------------------------------------------------------------------------
  // إلغاء التحميل
  // ---------------------------------------------------------------------------

  /// إلغاء عملية تحميل قارئ معين
  void cancelDownload(String qariId) {
    final token = _cancelTokens[qariId];
    if (token != null && !token.isCancelled) {
      token.cancel('تم الإلغاء من قِبَل المستخدم');
      _cancelTokens.remove(qariId);
      _progressCallbacks.remove(qariId);
      _errorCallbacks.remove(qariId);
      _currentProgress.remove(qariId);
      AppLogger.logger.i('تم إلغاء تحميل القارئ $qariId');
    }
  }

  /// إلغاء جميع عمليات التحميل الجارية
  void cancelAllDownloads() {
    for (final entry in _cancelTokens.entries) {
      if (!entry.value.isCancelled) {
        entry.value.cancel('تم إلغاء جميع عمليات التحميل');
      }
    }
    _cancelTokens.clear();
    _progressCallbacks.clear();
    _errorCallbacks.clear();
    _currentProgress.clear();
  }

  // ---------------------------------------------------------------------------
  // حذف الملفات
  // ---------------------------------------------------------------------------

  /// حذف سورة واحدة من جهاز المستخدم
  Future<void> deleteSurah(String qariId, int surahNumber) async {
    final path = await getSurahLocalPath(qariId, surahNumber);
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      AppLogger.logger.i('تم حذف السورة $surahNumber للقارئ $qariId');
    }
  }

  /// حذف جميع سور قارئ معين
  Future<void> deleteAllQariSurahs(String qariId) async {
    final folderPath = await getQariFolderPath(qariId);
    final folder = Directory(folderPath);
    if (await folder.exists()) {
      await folder.delete(recursive: true);
      AppLogger.logger.i('تم حذف جميع سور القارئ $qariId');
    }
    // مسح سجل الاستكمال
    await _clearLastDownloadedSurah(qariId);
  }

  /// حساب حجم الملفات المُحمَّلة لقارئ معين بالميغابايت
  Future<double> getDownloadedSizeMB(String qariId) async {
    final folderPath = await getQariFolderPath(qariId);
    final folder = Directory(folderPath);
    if (!await folder.exists()) return 0.0;

    int totalBytes = 0;
    await for (final entity in folder.list(recursive: true)) {
      if (entity is File) {
        totalBytes += await entity.length();
      }
    }
    return totalBytes / (1024 * 1024);
  }
}
