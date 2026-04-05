# خطة تنفيذ: Background Audio Service لتطبيق "نور القرآن"

## الهدف

دمج `just_audio_background` في التطبيق لتمكين التحكم في تشغيل الصوت من شاشة القفل ومركز الإشعارات، مع عرض اسم السورة واسم القارئ وأزرار التحكم (تشغيل/إيقاف، تقديم/تأخير بـ 10 ثوانٍ).

## الوضع الحالي (Current State)

| الملف | الوضع |
|---|---|
| `audio_player_provider.dart` | يستخدم `AudioPlayer()` عادياً من `just_audio` |
| `moratal_player_provider.dart` | يستدعي `audioPlayer.setUrl(url)` بدون `MediaItem` |
| `main.dart` | لا يوجد `JustAudioBackground.init()` |
| `AndroidManifest.xml` | لا يوجد `<service>` خاص بـ AudioService |
| `pubspec.yaml` | `just_audio: ^0.10.5` موجود، لكن `just_audio_background` غير موجود |

---

## الملاحظات التي تستوجب المراجعة

> [!IMPORTANT]
> **تعارض المشغّلين (Player Conflict):**
> يوجد حالياً مشغّل صوت **واحد مشترك** (`audioPlayerProvider`) يُستخدم لتشغيل الآيات آية بآية في صفحة القرآن، وأيضاً لتشغيل السور كاملة في "القرآن مُرتل". هذا التصميم جيد ولن يتغير، لكنه يعني أن `just_audio_background` سيحكم على **كلا** الميزتين.

> [!WARNING]
> **إضافة الحزمة just_audio_background:**
> هذا يتطلب تعديل `pubspec.yaml` وتثبيت الحزمة ثم تعديل كود Kotlin في `MainActivity.kt` لإضافة AudioServicePlugin.

> [!NOTE]
> **صورة الإشعار (artUri):**
> سيتم استخدام أيقونة التطبيق `moon.png` كصورة الإشعار. تحتاج `artUri` أن تكون URI قابلة للوصول (asset أو URL)، وسنستخدم `AssetImage` عبر خاصية `extras` أو path مناسب، أو بديلاً نستعمل `Uri.parse('android.resource://...')`.

---

## التغييرات المقترحة

### ١. إضافة الحزمة

#### [MODIFY] [pubspec.yaml](file:///c:/Users/adnan/Desktop/MyProjcts/flutter_apps/noor_bayan/noor_bayan/pubspec.yaml)
- إضافة `just_audio_background: ^0.0.1-beta.12` تحت `just_audio`

---

### ٢. تهيئة الـ Background Service

#### [MODIFY] [main.dart](file:///c:/Users/adnan/Desktop/MyProjcts/flutter_apps/noor_bayan/noor_bayan/lib/main.dart)
- إضافة `import 'package:just_audio_background/just_audio_background.dart';`
- استدعاء `await JustAudioBackground.init(...)` قبل `runApp()` مع الإعدادات:
  ```dart
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.noorquran.audio',
    androidNotificationChannelName: 'نور القرآن - تشغيل الصوت',
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true,
    notificationColor: Color(0xFF1E8449), // لون التطبيق
  );
  ```

---

### ٣. تحديث مصدر الصوت في Provider المُرتَّل

#### [MODIFY] [moratal_player_provider.dart](file:///c:/Users/adnan/Desktop/MyProjcts/flutter_apps/noor_bayan/noor_bayan/lib/features/quran_moratal/presentation/providers/moratal_player_provider.dart)
استبدال `audioPlayer.setUrl(url)` بـ:
```dart
await audioPlayer.setAudioSource(
  AudioSource.uri(
    Uri.parse(url),
    tag: MediaItem(
      id: '${surah.qariId}_${surah.surahNumber}',
      title: 'سورة ${surah.surahName}',
      artist: surah.qariName,
      artUri: Uri.parse('asset:///assets/icons/moon.png'),
    ),
  ),
);
```
مع `try-catch` شامل.

---

### ٤. تحديث مصدر الصوت عند تشغيل الآيات (آية بآية)

#### [MODIFY] [audio_player_provider.dart](file:///c:/Users/adnan/Desktop/MyProjcts/flutter_apps/noor_bayan/noor_bayan/lib/features/quran/presentation/providers/audio_player_provider.dart)
- تحديث `player.setUrl(url)` ليصبح `setAudioSource` مع `MediaItem` يحتوي اسم السورة ورقم الآية في الـ `title`.

---

### ٥. إضافة أزرار Skip Forward/Backward بـ 10 ثوانٍ

#### [MODIFY] [moratal_mini_player.dart](file:///c:/Users/adnan/Desktop/MyProjcts/flutter_apps/noor_bayan/noor_bayan/lib/features/quran_moratal/presentation/widgets/moratal_mini_player.dart)
- في `_MoratalFullPlayerSheet`:
  - إضافة زرَّي `seekForward(10s)` و `seekBackward(10s)` في صف عناصر التحكم الرئيسية
  - هذه الأزرار ستظهر تلقائياً في الإشعار لأن `just_audio_background` يتعامل مع ذلك عبر `androidNotificationIcon`

---

### ٦. تعديل AndroidManifest.xml

#### [MODIFY] [AndroidManifest.xml](file:///c:/Users/adnan/Desktop/MyProjcts/flutter_apps/noor_bayan/noor_bayan/android/app/src/main/AndroidManifest.xml)
إضافة الأذونات والـ services التالية:
```xml
<!-- أذونات الصوت في الخلفية -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>

<!-- خدمة just_audio_background -->
<service
    android:name="com.ryanheise.audioservice.AudioService"
    android:foregroundServiceType="mediaPlayback"
    android:exported="true">
  <intent-filter>
    <action android:name="android.media.browse.MediaBrowserService" />
  </intent-filter>
</service>

<receiver android:name="com.ryanheise.audioservice.MediaButtonReceiver"
    android:exported="true">
  <intent-filter>
    <action android:name="android.intent.action.MEDIA_BUTTON" />
  </intent-filter>
</receiver>
```

---

### ٧. تعديل MainActivity.kt

#### [MODIFY] [MainActivity.kt](file:///c:/Users/adnan/Desktop/MyProjcts/flutter_apps/noor_bayan/noor_bayan/android/app/src/main/kotlin)
استبدال `FlutterActivity` بـ `FlutterFragmentActivity` حسب متطلبات `just_audio_background`.

---

## خطوات التنفيذ بالترتيب

```
1. [ ] إضافة just_audio_background في pubspec.yaml
2. [ ] تشغيل flutter pub get
3. [ ] تعديل main.dart - إضافة JustAudioBackground.init()
4. [ ] تعديل moratal_player_provider.dart - استخدام AudioSource.uri مع MediaItem
5. [ ] تعديل audio_player_provider.dart - استخدام setAudioSource مع MediaItem للآيات
6. [ ] تعديل moratal_mini_player.dart - إضافة أزرار seek +10/-10 ثانية
7. [ ] تعديل AndroidManifest.xml - إضافة الأذونات والـ service
8. [ ] تعديل MainActivity.kt - FlutterFragmentActivity
9. [ ] اختبار وتشغيل
```

## خطة التحقق (Verification)

- تشغيل سورة من القسم المُرتَّل والتحقق من ظهور الإشعار بـ: اسم السورة، اسم القارئ، شعار التطبيق
- التحقق من عمل أزرار Play/Pause من الإشعار
- تأمين الشاشة والتحقق من ظهور مشغّل الصوت في شاشة القفل مع أزرار التحكم
- الضغط على زر Skip Forward/Backward من الإشعار والتحقق من الانتقال 10 ثوانٍ
- التحقق من استمرار تشغيل الصوت عند إغلاق التطبيق أو تبديل التطبيقات
