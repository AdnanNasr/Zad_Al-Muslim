import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:noor_quran/core/database/isar_db.dart';


import 'package:noor_quran/features/pray_time/presentation/providers/schedule_prayer_time_notification.dart';
import 'package:noor_quran/features/pray_time/data/models/prayer_times_model.dart';
import 'package:noor_quran/core/utils/log/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:isar/isar.dart';

import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/core/utils/location/location_locator.dart';

part 'pray_times_notifier.g.dart';


@riverpod
class PrayTimesNotifier extends _$PrayTimesNotifier {
  @override
  FutureOr<void> build() async {
    final Isar? db = IsarDb.database;
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    // this notifier performs background work, and we may read it before any
    // listeners are attached (e.g. in main). keep it alive to avoid disposal
    // while an async method is running; otherwise Riverpod may try to complete
    // its internal future again and we get ``Bad state: Future already completed``.
    ref.keepAlive();
    if (db == null) return;
    final todayTimes = await db.prayerTimesModels
        .filter()
        .dateEqualTo(today)
        .findFirst();
    try {
      if (todayTimes != null) {
        await _scheduleDailyNotifications(todayTimes);
        AppLogger.logger.i("تم جدولة مواعيد الصلاة للإشعارات بنجاح");
      }
    } catch (e) {
      AppLogger.logger.i("حصل خطأ اثناء جدولة صلاوات اليوم\nvرمز الخطأ: $e");
    }
    // return null;
  }

  Isar? get _db => IsarDb.database;

  /// يحاول إرجاع مواقيت الصلاة لليوم من قاعدة البيانات.
  /// إذا لم تكن موجودة، يحسبها باستخدام مكتبة `adhan`، يحفظها ثم يعيدها.
  Future<PrayerTimesModel?> loadToday({required Position position}) async {
    final now = DateTime.now();
    final dateOnly = DateTime(now.year, now.month, now.day);

    // حاول قراءة السجل من القاعدة
    PrayerTimesModel? existing = await _db?.prayerTimesModels
        .filter()
        .dateEqualTo(dateOnly)
        .findFirst();

    if (existing != null) {
      return existing;
    }

    // إذا لم يوجد، أحسبه باستخدام الموقع الممرر
    final coordinates = Coordinates(position.latitude, position.longitude);
    final settings = await getAutomaticParams(
      position.latitude,
      position.longitude,
    );
    final adhanTimes = PrayerTimes(
      coordinates,
      DateComponents.from(now),
      settings,
    );

    final newModel = _convertToDbModel(adhanTimes, now);
    await _db?.writeTxn(() async {
      await _db?.prayerTimesModels.put(newModel);
    });
    return newModel;
  }

  /// إعدادات الحساب (مذهب الشافعي كمثال)
  Future<CalculationParameters> getAutomaticParams(
    double lat,
    double lng,
  ) async {
    final locationLocator = sl<LocationLocatorImpl>();
    return await locationLocator.getCalculationParameters(lat, lng);
  }



  /// تحويل كائن المكتبة الخارجية إلى موديل قاعدة البيانات المحلي
  PrayerTimesModel _convertToDbModel(PrayerTimes adhanTimes, DateTime date) {
    return PrayerTimesModel()
      ..date = DateTime(date.year, date.month, date.day)
      ..fajr = adhanTimes.fajr
      ..sunrise = adhanTimes.sunrise
      ..dhuhr = adhanTimes.dhuhr
      ..asr = adhanTimes.asr
      ..maghrib = adhanTimes.maghrib
      ..isha = adhanTimes.isha;
  }

  /// حساب وحفظ مواقيت الشهر بالكامل في قاعدة البيانات
  Future<void> fetchAndSaveMonthlyTimes({
    required double latitude,
    required double longitude,
    int? year,
    int? month,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final now = DateTime.now();
      final targetYear = year ?? now.year;
      final targetMonth = month ?? now.month;

      final coordinates = Coordinates(latitude, longitude);
      final settings = await getAutomaticParams(latitude, longitude);
      final List<PrayerTimesModel> monthlyList = [];

      final daysInMonth = DateTime(targetYear, targetMonth + 1, 0).day;

      for (int day = 1; day <= daysInMonth; day++) {
        final date = DateTime(targetYear, targetMonth, day);
        final adhanTimes = PrayerTimes(
          coordinates,
          DateComponents.from(date),
          settings,
        );
        monthlyList.add(_convertToDbModel(adhanTimes, date));
      }

      await _db?.writeTxn(() async {
        await _db?.prayerTimesModels.putAll(monthlyList);
      });
    });
  }

  /// حساب وحفظ مواقيت السنة كاملة في قاعدة البيانات
  Future<void> fetchAndSaveYearlyTimes({
    required int year,
    required double latitude,
    required double longitude,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final List<PrayerTimesModel> yearlyList = [];
      final coordinates = Coordinates(latitude, longitude);
      final settings = await getAutomaticParams(latitude, longitude);

      for (int month = 1; month <= 12; month++) {
        final daysInMonth = DateTime(year, month + 1, 0).day;
        for (int day = 1; day <= daysInMonth; day++) {
          final date = DateTime(year, month, day);
          final adhanTimes = PrayerTimes(
            coordinates,
            DateComponents.from(date),
            settings,
          );
          yearlyList.add(_convertToDbModel(adhanTimes, date));
        }
      }

      await _db?.writeTxn(() async {
        await _db?.prayerTimesModels.putAll(yearlyList);
      });
    });
  }

  // داخل PrayTimesNotifier

  // داخل كلاس PrayTimesNotifier

  Future<void> _scheduleDailyNotifications(PrayerTimesModel todayTimes) async {
    // 1. مسح أي إشعارات قديمة مجدولة لتجنب التكرار أو تداخل الأصوات
    await FlutterLocalNotificationsPlugin().cancelAll();

    // 2. تجهيز قائمة الصلوات وأوقاتها
    final Map<String, DateTime?> prayers = {
      'الفجر': todayTimes.fajr,
      'الظهر': todayTimes.dhuhr,
      'العصر': todayTimes.asr,
      'المغرب': todayTimes.maghrib,
      'العشاء': todayTimes.isha,
    };

    // 3. المرور على كل صلاة وجدولتها
    int idCounter = 0;
    for (var entry in prayers.entries) {
      final String name = entry.key;
      final DateTime? time = entry.value;

      if (time != null) {
        await SchedulePrayerTimeNotification.schedulePrayerNotification(
          id: idCounter++,
          title: name,
          time: time,
        );
      }
    }

    AppLogger.logger.i("✅ تم جدولة إشعارات اليوم بنجاح");
  }
}
