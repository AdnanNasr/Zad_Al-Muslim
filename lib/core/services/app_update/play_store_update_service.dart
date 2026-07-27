import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';

class PlayStoreUpdateException implements Exception {
  const PlayStoreUpdateException(this.message);
  final String message;
  @override
  String toString() => message;
}

class PlayStoreUpdateService {
  bool _operationInProgress = false;

  Future<void> startFlexibleUpdate() =>
      _runUpdate(immediate: false);

  Future<void> startImmediateUpdate() =>
      _runUpdate(immediate: true);

  Future<void> _runUpdate({required bool immediate}) async {
    if (kIsWeb || !Platform.isAndroid) {
      throw const PlayStoreUpdateException('التحديث الداخلي متاح على Android فقط.');
    }
    if (_operationInProgress) {
      throw const PlayStoreUpdateException('هناك عملية تحديث قيد التنفيذ.');
    }

    _operationInProgress = true;
    try {
      final info = await InAppUpdate.checkForUpdate();
      final available = info.updateAvailability ==
              UpdateAvailability.updateAvailable ||
          info.updateAvailability ==
              UpdateAvailability.developerTriggeredUpdateInProgress;
      if (!available) {
        throw const PlayStoreUpdateException(
          'لا يتوفر تحديث عبر Google Play لهذا التثبيت.',
        );
      }

      if (immediate) {
        if (!info.immediateUpdateAllowed) {
          throw const PlayStoreUpdateException(
            'التحديث الفوري غير مسموح من Google Play.',
          );
        }
        final result = await InAppUpdate.performImmediateUpdate();
        if (result != AppUpdateResult.success) {
          throw const PlayStoreUpdateException('لم يكتمل التحديث الفوري.');
        }
      } else {
        if (!info.flexibleUpdateAllowed) {
          throw const PlayStoreUpdateException(
            'التحديث المرن غير مسموح من Google Play.',
          );
        }
        final result = await InAppUpdate.startFlexibleUpdate();
        if (result != AppUpdateResult.success) {
          throw const PlayStoreUpdateException('لم يكتمل تنزيل التحديث.');
        }
        await InAppUpdate.completeFlexibleUpdate();
      }
    } catch (error, stackTrace) {
      AppLogger.logger.e(
        'فشل Google Play In-App Update: $error',
        stackTrace: stackTrace,
      );
      rethrow;
    } finally {
      _operationInProgress = false;
    }
  }

  Future<void> openStore(String storeUrl) async {
    final uri = Uri.tryParse(storeUrl);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw const PlayStoreUpdateException('تعذر فتح صفحة التطبيق في المتجر.');
    }
  }
}
