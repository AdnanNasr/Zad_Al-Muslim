import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:noor_quran/view_models/utils/app_logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

double progress = 0; // متغير لتخزين النسبة

// لتتبع التنزيلات الجارية
Map<String, double> activeDownloads = {};
const String _activeDownloadsKey = "active_downloads";
const String _downloadedTafseersKey = "downloaded_tafseer_list";
const String _pendingDownloadsKey = "pending_downloads"; // لتخزين التنزيلات المعلقة

// دالة للتحقق من وجود الملف المحمل فعلياً
Future<bool> isTafseerDownloaded(String tafseerName) async {
  var dir = await getApplicationDocumentsDirectory();
  String savePath = "${dir.path}/$tafseerName";
  return File(savePath).exists();
}

// دالة للتحقق من جميع الملفات المحملة عند بدء التطبيق
Future<List<String>> getDownloadedTafseers(List<String> tafseerIds) async {
  List<String> downloaded = [];
  
  for (String id in tafseerIds) {
    if (await isTafseerDownloaded(id)) {
      downloaded.add(id);
    }
  }
  
  return downloaded;
}

// حفظ حالة التنزيل فوراً
Future<void> markTafseerAsDownloaded(String tafseerName) async {
  final prefs = await SharedPreferences.getInstance();
  final savedList = prefs.getStringList(_downloadedTafseersKey) ?? [];
  
  if (!savedList.contains(tafseerName)) {
    savedList.add(tafseerName);
    await prefs.setStringList(_downloadedTafseersKey, savedList);
  }
  
  // إزالة من التنزيلات الجارية عند الانتهاء
  await removeFromActiveDownloads(tafseerName);
}

// حفظ التنزيلات الجارية
Future<void> addToActiveDownloads(String tafseerName, double progress) async {
  activeDownloads[tafseerName] = progress;
  
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    _activeDownloadsKey,
    activeDownloads.entries
        .map((e) => '${e.key}:${e.value}')
        .join(','),
  );
}

// الحصول على التنزيلات الجارية
Future<Map<String, double>> getActiveDownloads() async {
  final prefs = await SharedPreferences.getInstance();
  final activeStr = prefs.getString(_activeDownloadsKey) ?? '';
  
  if (activeStr.isEmpty) return {};
  
  Map<String, double> result = {};
  for (String entry in activeStr.split(',')) {
    if (entry.isNotEmpty) {
      var parts = entry.split(':');
      if (parts.length == 2) {
        result[parts[0]] = double.tryParse(parts[1]) ?? 0.0;
      }
    }
  }
  return result;
}

// إزالة من التنزيلات الجارية
Future<void> removeFromActiveDownloads(String tafseerName) async {
  activeDownloads.remove(tafseerName);
  
  final prefs = await SharedPreferences.getInstance();
  if (activeDownloads.isEmpty) {
    await prefs.remove(_activeDownloadsKey);
  } else {
    await prefs.setString(
      _activeDownloadsKey,
      activeDownloads.entries
          .map((e) => '${e.key}:${e.value}')
          .join(','),
    );
  }
}

// إضافة تنزيل معلق
Future<void> addPendingDownload(String tafseerName, String url) async {
  final prefs = await SharedPreferences.getInstance();
  final pending = prefs.getString(_pendingDownloadsKey) ?? '';
  
  final newEntry = '$tafseerName|$url';
  if (pending.isEmpty) {
    await prefs.setString(_pendingDownloadsKey, newEntry);
  } else {
    await prefs.setString(_pendingDownloadsKey, '$pending\n$newEntry');
  }
}

// الحصول على التنزيلات المعلقة
Future<Map<String, String>> getPendingDownloads() async {
  final prefs = await SharedPreferences.getInstance();
  final pending = prefs.getString(_pendingDownloadsKey) ?? '';
  
  final result = <String, String>{};
  for (String line in pending.split('\n')) {
    if (line.isNotEmpty) {
      final parts = line.split('|');
      if (parts.length == 2) {
        result[parts[0]] = parts[1];
      }
    }
  }
  return result;
}

// إزالة تنزيل معلق
Future<void> removePendingDownload(String tafseerName) async {
  final prefs = await SharedPreferences.getInstance();
  final pending = prefs.getString(_pendingDownloadsKey) ?? '';
  
  final lines = pending.split('\n').where((line) {
    return !line.startsWith('$tafseerName|');
  }).toList();
  
  final result = lines.join('\n');
  if (result.isEmpty) {
    await prefs.remove(_pendingDownloadsKey);
  } else {
    await prefs.setString(_pendingDownloadsKey, result);
  }
}

Future<void> downloadTafseer(
  String url,
  String fileName, {
  required void Function(double) onProgress,
  required void Function() onComplete,
  required void Function(String) onError,
}) async {
  Dio dio = Dio();

  // الحصول على مسار الحفظ في الهاتف
  var dir = await getApplicationDocumentsDirectory();
  String savePath = "${dir.path}/$fileName";

  try {
    // التحقق إذا كان الملف موجود بالفعل
    if (await File(savePath).exists()) {
      // الملف موجود بالفعل، قم بحفظه وأكمل
      await markTafseerAsDownloaded(fileName);
      print("الملف: $fileName موجود بالفعل");
      onProgress(1.0);
      onComplete();
      return;
    }

    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          // حساب النسبة المئوية
          progress = received / total;
          onProgress(progress);
          // حفظ حالة التنزيل الجارية
          addToActiveDownloads(fileName, progress);
          AppLogger.logger.i("التحميل: ${(progress * 100).toStringAsFixed(0)}%");
        }
      },
    );
    
    print("تم التحميل بنجاح في: $savePath");
    // حفظ الحالة فوراً عند اكتمال التحميل
    await markTafseerAsDownloaded(fileName);
    onComplete();
    
  } on DioException catch (e) {
    String errorMessage = "خطأ في التحميل: ${e.message}";
    AppLogger.logger.e(errorMessage);
    await removeFromActiveDownloads(fileName);
    onError(errorMessage);
  } catch (e) {
    String errorMessage = "خطأ في التحميل: $e";
    AppLogger.logger.e(errorMessage);
    await removeFromActiveDownloads(fileName);
    onError(errorMessage);
  }
}

