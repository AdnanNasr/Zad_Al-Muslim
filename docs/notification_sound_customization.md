# تخصيص أصوات الإشعارات

## Overview

تتيح هذه الميزة للمستخدم اختيار صوت كل فئة إشعارات من إعدادات Android. لا يضيف التطبيق أي ملف صوتي ولا يحاول حفظ صوت ظاهري داخل `SharedPreferences`؛ Android هو مصدر الحقيقة لصوت كل Notification Channel.

## Architecture

تقع الوحدة القابلة لإعادة الاستخدام في `lib/core/notification_sound/`:

- `notification_sound_manager.dart`: سجل القنوات الثابت، إنشاؤها بصورة آمنة ومتكررة، تفاصيل Android، فتح إعدادات النظام، ونقطة تكامل وضع صوت الصلاة.
- `notification_sound_settings_dialog.dart`: واجهة Flutter صغيرة تستهلك الواجهة العامة للوحدة فقط، ولا تحتوي على Android intents.

Android Intent موجود في `MainActivity.kt` خلف `MethodChannel` باسم `com.zad_al_muslim.adnan/notification_sound_settings`.

## Notification Channels

| Channel ID | الاسم | النوع | الصوت |
| --- | --- | --- | --- |
| `prayer_times_channel` | مواقيت الصلاة | الصلاة، وضع صوت إشعار | صوت Android الافتراضي عند أول إنشاء؛ قابل للتخصيص من النظام |
| `quran_reading_id` | تنبيهات الورد القرآني | الورد القرآني | صوت Android الافتراضي عند أول إنشاء؛ قابل للتخصيص من النظام |
| `morning_adkar_id` | أذكار الصباح | أذكار الصباح | صوت Android الافتراضي عند أول إنشاء؛ قابل للتخصيص من النظام |
| `evening_adkar_id` | أذكار المساء | أذكار المساء | صوت Android الافتراضي عند أول إنشاء؛ قابل للتخصيص من النظام |
| `prayer_times_adhan` | مواقيت الصلاة - الأذان | الصلاة، وضع الأذان | بلا صوت إشعار؛ تشغيل الأذان خارج نطاق هذه الميزة |
| `prayer_times_silent_vibration` | مواقيت الصلاة - اهتزاز صامت | الصلاة، وضع الصامت | بلا صوت مع اهتزاز |

## Files Created

- `lib/core/notification_sound/notification_sound_manager.dart`: الوحدة المستقلة.
- `lib/core/notification_sound/notification_sound_settings_dialog.dart`: واجهة إعدادات الصوت.
- `docs/notification_sound_customization.md`: هذا التقرير.

## Files Modified

- `lib/app_bootstrap.dart`: إنشاء القنوات بعد تهيئة الإشعارات.
- `lib/infrastructure/repositories/notification_scheduler_impl.dart`: استخدام قناة الصلاة المناسبة.
- `lib/features/pray_time/presentation/providers/schedule_prayer_time_notification.dart`: توحيد مسار الصلاة القديم مع القنوات الجديدة.
- `lib/features/quran/presentation/providers/schedule_quran_reading_notification.dart`: استخدام قناة الورد المسجلة.
- `lib/features/settings/presentation/providers/schedule_adkar_notification.dart`: استخدام قناتي أذكار الصباح والمساء المسجلتين.
- `lib/features/settings/presentation/pages/settings_page.dart`: إضافة مدخل «أصوات الإشعارات».
- `android/app/src/main/AndroidManifest.xml`: تشغيل `MainActivity` (الوارثة من `AudioServiceActivity`) حتى يُسجّل Android MethodChannel.
- `android/app/src/main/kotlin/com/zad_al_muslim/adnan/MainActivity.kt`: فتح إعدادات إشعارات التطبيق أو Channel محددة عبر Android APIs.

## Android Implementation

ينشئ `NotificationSoundManager.ensureChannels` القنوات ذات المعرّفات الثابتة. عملية `createNotificationChannel` آمنة عند تكرارها، ولا تنشئ نسخة جديدة لقناة بالمعرّف نفسه. كل جدولة تستخدم تعريف القناة نفسه بدلاً من إنشاء قناة جديدة.

## User Settings

من «الإعدادات» ثم «أصوات الإشعارات»، يفتح المستخدم إعدادات Android المباشرة لكل فئة أو إعدادات إشعارات التطبيق عامة. يعرض Android الصوت الذي اختاره فعليًا ويمكّن تغييره.

## Prayer Notification Integration

`PrayerNotificationAudioMode` يوفّر نقطة التكامل التالية:

- `notification`: يستخدم `prayer_times_channel`، ومن ثم يتبع صوت القناة الذي اختاره المستخدم في Android.
- `adhan`: يستخدم قناة مرئية بلا صوت إشعار، فلا يوضع صوت Notification فوق مشغّل الأذان المستقبلي.
- `silentVibration`: يستخدم قناة بلا صوت مع اهتزاز.

لا توجد في الإصدار الحالي آلية أذان عاملة أو اختيار مخزّن لهذه الأوضاع في المشروع؛ لذلك يحافظ التطبيق على السلوك المنشور الحالي (`notification`) افتراضيًا. توجد `setPrayerAudioMode` لتستدعيها ميزة الأذان لاحقًا. هذه المرحلة لا تشغل الأذان ولا تضيف ملفاته ولا تعدّل آلية تشغيله.

## Migration

احتُفظ بمعرّفات القنوات القائمة (`prayer_times_channel` و`quran_reading_id` و`morning_adkar_id` و`evening_adkar_id`) حتى يستمر صوت المستخدم وإعداداته الموجودة بعد التحديث. لا تُحذف أي قناة ولا تُلغى إشعارات مجدولة بسبب إنشاء القنوات. قناة `prayer_id` الموجودة في مسار صلاة قديم لم تعد مستخدمة في أي جدولة جديدة؛ تبقى لدى Android إلى أن يحذفها المستخدم أو يعيد تثبيت التطبيق.

## Limitations

بعد إنشاء Channel، Android والمستخدم يملكان التحكم النهائي بالصوت والاهتزاز والأهمية. لا تستطيع Flutter تغيير صوت Channel موجود برمجيًا، ولا يمكن للتطبيق قراءة اسم صوت النظام المختار بشكل موثوق؛ لذلك لا تعرض الواجهة اسمًا مضللًا للصوت.

## Testing

- شُغّل `dart format` على الملفات المتأثرة بنجاح.
- طُلب `dart analyze`؛ بدأت العملية، لكن بيئة التشغيل المقيدة منعت Dart من تحديث ملف telemetry خارج مساحة العمل قبل ظهور النتيجة النهائية.
- لم يتوفر جهاز Android/محاكي متصل في بيئة العمل، لذلك لم يُدّعَ اختبار القنوات أو الحالات الثلاث على جهاز فعلي.

يجب التحقق يدويًا على Android من فتح إعدادات القنوات، تغيير صوت كل قناة، الاستمرار بعد إعادة تشغيل الجهاز، وترحيل تثبيت قديم، ثم تجربة أوضاع الصلاة الثلاث عندما تتوفر ميزة الأذان.

## Reusability

لنقل الوحدة، انسخ مجلد `notification_sound`، بدّل قائمة القنوات/النصوص فقط، واربط MethodChannel نفسه بتطبيق Android الهدف. تقبل الوحدة `FlutterLocalNotificationsPlugin` في إنشاء القنوات ولا تعتمد على Riverpod.

## Future Integration

ميزة الأذان المستقبلية عليها استدعاء `NotificationSoundManager.setPrayerAudioMode` عند تغيير اختيار المستخدم، وتشغيل ملف الأذان الخاص بها فقط في وضع `adhan`. لا ينبغي لها استخدام `prayer_times_channel` في ذلك الوضع، حتى لا تضيف صوت إشعار عادي فوق الأذان.
