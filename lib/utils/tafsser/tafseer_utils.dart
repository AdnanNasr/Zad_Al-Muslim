import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/view_models/models/db/islamic/tafsser/ayah.dart';
import 'package:noor_quran/view_models/repositories/insert_tafsser.dart';
import 'package:noor_quran/view_models/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noor_quran/view_models/models/db/isar_db.dart';
import 'package:noor_quran/view_models/models/db/islamic/tafsser/tafsser_surah.dart';

// المفاتيح المستخدمة في التخزين الدائم
const String _activeDownloadsKey = "active_downloads";
const String _pendingDownloadsKey = "pending_downloads";

class TafseerUtils {
  // ---------------------------------------------------------
  // 1. منطق Isar والبيانات
  // ---------------------------------------------------------

  static Future<bool> isTafseerDownloaded(String identifier) async {
    final isar = IsarDb.database;
    if (isar == null) return false;
    final count = await isar.tafsserSurahs
        .filter()
        .edition((q) => q.identifierEqualTo(identifier))
        .count();
    return count > 0;
  }

  static Future<void> downloadTafseer({
    required String url,
    required void Function(double) onProgress,
    required void Function() onComplete,
    required void Function(String) onError,
  }) async {
    final dio = Dio();

    try {
      // 1. تعريف المتغير في الأعلى ليكون متاحاً في كامل النطاق
      Response response;

      try {
        response = await dio.get(
          url,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              onProgress((received / total) * 0.9);
            }
          },
        );
      } on FormatException catch (e) {
        // هذا النوع من الأخطاء نادراً ما يحدث في طلب get نفسه، بل عند تحليل البيانات
        onError("تنسيق الرابط غير صحيح: ${e.message}");
        return; // توقف عن التنفيذ
      }

      // 2. الآن يمكنك استخدام response هنا بأمان
      if (response.statusCode == 200) {
        // تأكد أن response.data ليس null قبل تمريره
        if (response.data != null) {
          await insertTafsserToIsar(jsonMap: response.data);
          onProgress(1.0);
          onComplete();
        } else {
          onError("السيرفر أعاد استجابة فارغة");
        }
      } else {
        onError("خطأ في السيرفر: ${response.statusCode}");
      }
    } on DioException catch (e) {
      // معالجة أخطاء الشبكة الخاصة بـ Dio
      String errorMessage = "خطأ في الاتصال";
      if (e.type == DioExceptionType.connectionTimeout)
        errorMessage = "انتهت مهلة الاتصال";
      onError("$errorMessage: ${e.message}");
    } on FormatException catch (e) {
      // معالجة أخطاء تحويل البيانات (JSON)
      onError("خطأ في تحليل البيانات المرسلة من السيرفر");
      AppLogger.logger.e("Format Error: ${e.message}");
    } catch (e) {
      // معالجة أي خطأ غير متوقع آخر
      onError("حدث خطأ غير متوقع: $e");
      AppLogger.logger.e("Unexpected Error: $e");
    }
  }

  static Future<void> deleteTafseer(String identifier) async {
    final isar = IsarDb.database;
    if (isar == null) return;
    await isar.writeTxn(() async {
      await isar.ayahTafssers
          .filter()
          .surah((q) => q.edition((e) => e.identifierEqualTo(identifier)))
          .deleteAll();
      await isar.tafsserSurahs
          .filter()
          .edition((q) => q.identifierEqualTo(identifier))
          .deleteAll();
    });
  }

  // ---------------------------------------------------------
  // 2. منطق التنزيلات الجارية (Active Downloads)
  // ---------------------------------------------------------

  static Future<void> addToActiveDownloads(String id, double progress) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, double> active = await getActiveDownloads();
    active[id] = progress;

    await prefs.setString(
      _activeDownloadsKey,
      active.entries.map((e) => '${e.key}:${e.value}').join(','),
    );
  }

  static Future<Map<String, double>> getActiveDownloads() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_activeDownloadsKey) ?? '';
    if (data.isEmpty) return {};

    Map<String, double> result = {};
    for (var entry in data.split(',')) {
      var parts = entry.split(':');
      if (parts.length == 2) {
        result[parts[0]] = double.tryParse(parts[1]) ?? 0.0;
      }
    }
    return result;
  }

  static Future<void> removeFromActiveDownloads(String id) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, double> active = await getActiveDownloads();
    active.remove(id);
    if (active.isEmpty) {
      await prefs.remove(_activeDownloadsKey);
    } else {
      await prefs.setString(
        _activeDownloadsKey,
        active.entries.map((e) => '${e.key}:${e.value}').join(','),
      );
    }
  }

  // ---------------------------------------------------------
  // 3. منطق التنزيلات المعلقة (Pending Downloads)
  // ---------------------------------------------------------

  static Future<void> addPendingDownload(String id, String url) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> pending = await getPendingDownloads();
    pending[id] = url;

    // حفظ الـ Map بالكامل كـ JSON String لمنع تداخل الحروف
    await prefs.setString(_pendingDownloadsKey, jsonEncode(pending));
  }

  static Future<Map<String, String>> getPendingDownloads() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_pendingDownloadsKey) ?? '';
    if (data.isEmpty) return {};

    try {
      // تحويل النص من JSON إلى Map بأمان
      final Map<String, dynamic> decoded = jsonDecode(data);
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      AppLogger.logger.e("خطأ في قراءة التحميلات المعلقة: $e");
      return {};
    }
  }

  static Future<void> removePendingDownload(String id) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> pending = await getPendingDownloads();

    if (pending.containsKey(id)) {
      pending.remove(id);
      if (pending.isEmpty) {
        await prefs.remove(_pendingDownloadsKey);
      } else {
        await prefs.setString(_pendingDownloadsKey, jsonEncode(pending));
      }
    }
  }
}
