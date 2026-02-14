import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/view_models/models/db/islamic/tafsser/ayah.dart';
import 'package:noor_quran/view_models/repositories/insert_tafsser.dart';
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
      final response = await dio.get(
        url,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress((received / total) * 0.9);
          }
        },
      );

      if (response.statusCode == 200) {
        // تمرير البيانات لدالة الإدخال المستقلة
        await insertTafsserToIsar(jsonMap: response.data);
        onProgress(1.0);
        onComplete();
      } else {
        onError("خطأ في السيرفر: ${response.statusCode}");
      }
    } on DioException catch (e) {
      onError("خطأ في الاتصال: ${e.message}");
    } catch (e) {
      onError("حدث خطأ غير متوقع: $e");
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
      if (parts.length == 2)
        result[parts[0]] = double.tryParse(parts[1]) ?? 0.0;
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

    await prefs.setString(
      _pendingDownloadsKey,
      pending.entries.map((e) => '${e.key}|$e.value').join('\n'),
    );
  }

  static Future<Map<String, String>> getPendingDownloads() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_pendingDownloadsKey) ?? '';
    if (data.isEmpty) return {};

    Map<String, String> result = {};
    for (var line in data.split('\n')) {
      var parts = line.split('|');
      if (parts.length == 2) result[parts[0]] = parts[1];
    }
    return result;
  }

  static Future<void> removePendingDownload(String id) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> pending = await getPendingDownloads();
    pending.remove(id);
    if (pending.isEmpty) {
      await prefs.remove(_pendingDownloadsKey);
    } else {
      await prefs.setString(
        _pendingDownloadsKey,
        pending.entries.map((e) => '${e.key}|$e.value').join('\n'),
      );
    }
  }
}
