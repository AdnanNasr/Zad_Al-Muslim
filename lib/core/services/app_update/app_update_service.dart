import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zad_al_muslim/core/services/app_update/app_update_model.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';

class AppUpdateService {
  AppUpdateService(this._remoteConfig);

  final FirebaseRemoteConfig? _remoteConfig;

  static const _defaultTitle = 'يتوفر تحديث جديد';
  static const _defaultMessage =
      'حدّث التطبيق الآن للحصول على أحدث التحسينات والإصلاحات.';

  Future<AppUpdateModel> checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;
    final defaultStoreUrl =
        'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';

    final remoteConfig = _remoteConfig;
    if (kIsWeb ||
        !Platform.isAndroid ||
        Firebase.apps.isEmpty ||
        remoteConfig == null) {
      return _none(currentBuild, defaultStoreUrl);
    }

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 15),
        minimumFetchInterval: const Duration(hours: 6),
      ),
    );
    await remoteConfig.setDefaults({
      'update_enabled': false,
      'latest_android_build': currentBuild,
      'minimum_android_build': currentBuild,
      'update_title_ar': _defaultTitle,
      'update_message_ar': _defaultMessage,
      'play_store_url': defaultStoreUrl,
    });

    try {
      await remoteConfig.fetchAndActivate();
    } catch (error, stackTrace) {
      // يمكن استبدال AppLogger بـ Crashlytics في بيئة الإنتاج.
      AppLogger.logger.w(
        'تعذر تحديث Remote Config؛ ستُستخدم القيم المفعلة سابقًا: $error',
        stackTrace: stackTrace,
      );
    }

    final enabledValue = remoteConfig.getValue('update_enabled');
    final latestValue = remoteConfig.getValue('latest_android_build');
    final minimumValue = remoteConfig.getValue('minimum_android_build');
    final enabled = enabledValue.asBool();
    var latest = _safeBuild(latestValue.asString(), currentBuild);
    var minimum = _safeBuild(minimumValue.asString(), currentBuild);

    if (latest < minimum) {
      AppLogger.logger.w(
        'قيمة latest_android_build ($latest) أصغر من '
        'minimum_android_build ($minimum)؛ ستُرفع latest إلى minimum.',
      );
      latest = minimum;
    }

    final title = _nonEmpty(
      remoteConfig.getString('update_title_ar'),
      _defaultTitle,
    );
    final message = _nonEmpty(
      remoteConfig.getString('update_message_ar'),
      _defaultMessage,
    );
    final storeUrl = _validStoreUrl(
      remoteConfig.getString('play_store_url'),
      defaultStoreUrl,
    );
    final trusted = enabledValue.source == ValueSource.valueRemote &&
        minimumValue.source == ValueSource.valueRemote;

    final type = !enabled
        ? AppUpdateType.none
        : currentBuild < minimum
            ? AppUpdateType.required
            : currentBuild < latest
                ? AppUpdateType.optional
                : AppUpdateType.none;

    return AppUpdateModel(
      type: type,
      currentBuild: currentBuild,
      latestBuild: latest,
      minimumBuild: minimum,
      title: title,
      message: message,
      storeUrl: storeUrl,
      fromTrustedRemoteValue: trusted,
    );
  }

  int _safeBuild(String value, int fallback) {
    final parsed = int.tryParse(value.trim());
    return parsed != null && parsed >= 0 ? parsed : fallback;
  }

  String _nonEmpty(String value, String fallback) =>
      value.trim().isEmpty ? fallback : value.trim();

  String _validStoreUrl(String value, String fallback) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
            uri.hasScheme &&
            (uri.scheme == 'https' || uri.scheme == 'market')
        ? uri.toString()
        : fallback;
  }

  AppUpdateModel _none(int currentBuild, String storeUrl) => AppUpdateModel(
        type: AppUpdateType.none,
        currentBuild: currentBuild,
        latestBuild: currentBuild,
        minimumBuild: currentBuild,
        title: _defaultTitle,
        message: _defaultMessage,
        storeUrl: storeUrl,
      );
}
