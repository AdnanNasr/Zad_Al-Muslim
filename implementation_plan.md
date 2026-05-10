# خطة تنفيذ: نظام جدولة أوقات الصلاة (Islamic Prayer Scheduler)

## الهدف
بناء نظام قوي وفعال لإشعارات أوقات الصلاة باستخدام Clean Architecture، Isar، ومكتبة `adhan` و `flutter_local_notifications`. النظام يضمن دقة التوقيت، كفاءة استهلاك البطارية، والتعافي التلقائي بعد إعادة تشغيل الهاتف أو تغيير المنطقة الزمنية.

---

## ما تم تنفيذه (Completed Steps)

### STEP 1: طبقة الدومين (Domain Layer)
- [x] **الكيانات (Entities)**:
    - `PrayerTime`: يمثل صلاة واحدة مع وقت UTC ومنطقة زمنية محلية.
    - `Location`: يمثل الإحداثيات الجغرافية.
- [x] **الواجهات (Interfaces)**:
    - `IPrayerRepository`: لإدارة البيانات وتتبع حالة الجدولة والموقع الأخير.
    - `INotificationScheduler`: لإدارة دورة حياة التنبيهات.
- [x] **حالات الاستخدام (Use Cases)**:
    - `ScheduleNotificationsUseCase`: يجدول ٧ أيام من التنبيهات مع نافذة ٢٠ ساعة لمنع التكرار.
    - `RecalculateAndScheduleUseCase`: يحسب ٣٠ يوماً من الصلوات عند تغير الموقع (أكبر من 0.001 درجة).

### STEP 2: طبقة البنية التحتية (Infrastructure Layer)
- [x] **تخزين البيانات (Isar)**:
    - إنشاء `PrayerTimeEntity` مع دعم التحويل من وإلى Domain.
    - تشغيل `build_runner` لتوليد ملفات قاعدة البيانات.
- [x] **تنفيذ المستودع (IsarPrayerRepository)**:
    - تخزين أوقات الصلاة بصيغة UTC.
    - استخدام `SharedPreferences` لتخزين حالة الموقع وتاريخ آخر جدولة.
- [x] **جدولة التنبيهات (NotificationSchedulerImpl)**:
    - دعم `flutter_local_notifications` (v20+).
    - استخدام معرفات ثابتة `YYYYMMDDN`.
    - تفعيل نمط `exactAllowWhileIdle` لدقة التنبيه.

### STEP 3: دورة الحياة والتعافي (Lifecycle & Recovery)
- [x] **مراقب التطبيق (`AppLifecycleObserver`)**:
    - يراقب حالة الـ `resumed` للتحقق من تغير المنطقة الزمنية (Timezone Change).
- [x] **مستقبل التشغيل (`PrayerBootReceiver`)**:
    - كود Kotlin (Android) لإعادة تشغيل محرك Flutter وجدولة التنبيهات فور تشغيل الهاتف.

### STEP 4: إدارة التصاريح (Permissions)
- [x] **خدمة التصاريح (`PermissionService`)**:
    - طلب `SCHEDULE_EXACT_ALARM` لأندرويد ١٢+.
    - طلب `POST_NOTIFICATIONS` لأندرويد ١٣+.
    - طلب تصاريح الإشعارات لنظام iOS.

### STEP 5: حقن التبعيات (Dependency Injection)
- [x] **تحديث `injection_container.dart`**:
    - تسجيل جميع المكونات الجديدة وربطها مع `GetIt`.

### STEP 6: الربط النهائي (Final Wiring)
- [x] **في `main.dart`**:
    - تهيئة الـ Scheduler وتسجيل الـ Lifecycle Observer.
- [x] **في `splash_screen.dart`**:
    - طلب التصاريح عند بدء التشغيل.
    - تنفيذ أول عملية حساب وجدولة (Initial Calculation) لـ ٣٠ يوماً.
- [x] **تطهير الكود القديم (Cleanup)**:
    - تعطيل الجدولة القديمة في `PrayTimesNotifier` و `PrayerTimesRepositoryImpl` لمنع التداخل.

---

## الفوائد المحققة
1. **استهلاك أقل للبطارية**: لا توجد عمليات حسابية متكررة كلما فتح المستخدم التطبيق.
2. **دقة عالية**: استخدام UTC وتوقيت دقيق للنظام.
3. **ذكاء الموقع**: اكتشاف تغير الموقع والسفر وإعادة الجدولة تلقائياً.
4. **كود نظيف**: انفصال تام بين منطق الحساب وبين كيفية تخزين البيانات أو عرض الإشعارات.
