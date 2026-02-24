import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:noor_quran/utils/network_info.dart';
import 'package:noor_quran/utils/pray_times/schedule_prayer_time_notification.dart';
import 'package:noor_quran/view_models/models/prayer_times/prayer_times_model.dart';
import 'package:noor_quran/view_models/utils/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/view_models/models/db/isar_db.dart';

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
    try {
     final noInternet = await NetworkInfo.hasInvalidConnection();
    List<Placemark> placemarks = [];

    // 2. المحاولة فقط في حال وجود إنترنت
    if (!noInternet) {
      // تصحيح: يجب إسناد النتيجة للمتغير
      placemarks = await placemarkFromCoordinates(lat, lng)
          .timeout(const Duration(seconds: 5));
    }

    // 3. التحقق من أن القائمة ليست فارغة قبل محاولة الوصول لـ .first
    String countryCode = '';
    if (placemarks.isNotEmpty) {
      countryCode = placemarks.first.isoCountryCode?.toUpperCase() ?? '';
    }

      switch (countryCode) {
        // --- طريقة أم القرى ---
        case 'SA': // السعودية
          return CalculationMethod.umm_al_qura.getParameters();

        // --- الهيئة المصرية العامة للمساحة ---
        case 'EG': // مصر
        case 'SD': // السودان
        case 'LY': // ليبيا
        case 'SY': // سوريا
        case 'JO': // الأردن
        case 'PS': // فلسطين
        case 'LB': // لبنان
          return CalculationMethod.egyptian.getParameters();

        // --- طريقة دبي ---
        case 'AE': // الإمارات
        case 'BH': // البحرين
        case 'OM': // عمان
          return CalculationMethod.dubai.getParameters();

        // --- طريقة الكويت ---
        case 'KW': // الكويت
          return CalculationMethod.kuwait.getParameters();

        // --- طريقة قطر (متوفرة في الإصدارات الحديثة) ---
        case 'QA':
          return CalculationMethod.qatar.getParameters();

        // --- رئاسة الشؤون الدينية التركية ---
        case 'TR':
          return CalculationMethod.turkey.getParameters();

        // --- جامعة العلوم الإسلامية بكراتشي (المذهب الحنفي غالباً) ---
        case 'PK': // باكستان
        case 'AF': // أفغانستان
        case 'IN': // الهند
        case 'BD': // بنغلاديش
          final params = CalculationMethod.karachi.getParameters();
          params.madhab = Madhab.hanafi; // يفضل ضبط المذهب الحنفي لهذه الدول
          return params;

        // --- الجمعية الإسلامية لأمريكا الشمالية (ISNA) ---
        case 'US': // أمريكا
        case 'CA': // كندا
        case 'MX': // المكسيك
          return CalculationMethod.north_america.getParameters();

        // --- المجلس الديني الإسلامي في سنغافورة (MUIS) ---
        case 'SG': // سنغافورة
        case 'MY': // ماليزيا
        case 'ID': // إندونيسيا
          return CalculationMethod.singapore.getParameters();

        // --- معهد الجيوفيزياء بجامعة طهران ---
        case 'IR': // إيران
        case 'IQ': // العراق (للمناطق التي تتبع هذا الحساب)
          return CalculationMethod.tehran.getParameters();

        // --- روسيا ودول الاتحاد السوفيتي السابق ---
        case 'RU':
        case 'UA':
          return CalculationMethod.moon_sighting_committee.getParameters();

        // --- المغرب والجزائر (يدوياً لعدم وجود دالة جاهزة) ---
        case 'MA':
        case 'DZ':
        case 'TN':
          return CalculationParameters(fajrAngle: 19.0, ishaAngle: 17.0);

        // --- الخيار الافتراضي (رابطة العالم الإسلامي) ---
        // يغطي أوروبا (مثل بريطانيا وألمانيا) وبقية دول العالم
        default:
          return CalculationMethod.muslim_world_league.getParameters();
      }
    } on PlatformException catch (e) {
      // هذا سيمسك الخطأ الذي ظهر لك (IO_ERROR)
      AppLogger.logger.e("خطأ في خدمات النظام الجغرافية: ${e.message}");
      // العودة للخيار الافتراضي بدلاً من انهيار التطبيق
      return CalculationMethod.muslim_world_league.getParameters();
    } catch (e) {
      AppLogger.logger.e("خطأ غير متوقع: $e");
      return CalculationMethod.muslim_world_league.getParameters();
    }
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
