# إعداد نظام تحديث التطبيق

## ربط Firebase

المشروع لا يحتوي حاليًا على ملفات إعداد Firebase. ثبّت FlutterFire CLI ثم نفّذ:

```bash
flutterfire configure
```

اختر تطبيق Android ذي المعرّف `com.zad_al_muslim.adnan`. سيُنشئ الأمر
`firebase_options.dart` وملفات إعداد المنصة. عند استخدام الملف المولّد، مرّر
`DefaultFirebaseOptions.currentPlatform` إلى `Firebase.initializeApp`.

تهيئة Firebase الحالية محمية: إذا كانت الملفات غائبة أو فشل الاتصال، يستمر
التطبيق بالقيم الافتراضية ولا يُحجب المستخدم.

## مفاتيح Remote Config

أنشئ المعاملات التالية في Firebase Console ثم انشر التغييرات:

| المفتاح | النوع | القيمة الافتراضية المقترحة |
|---|---|---|
| `update_enabled` | Boolean | `false` |
| `latest_android_build` | Number | رقم build المنشور حاليًا |
| `minimum_android_build` | Number | أقدم build مسموح |
| `update_title_ar` | String | `يتوفر تحديث جديد` |
| `update_message_ar` | String | `حدّث التطبيق الآن للحصول على أحدث التحسينات والإصلاحات.` |
| `play_store_url` | String | `https://play.google.com/store/apps/details?id=com.zad_al_muslim.adnan` |

المقارنة تستخدم `PackageInfo.buildNumber` فقط. إذا كانت `latest` أصغر من
`minimum` تُعامل `latest` كأنها مساوية لـ `minimum` ويسجّل التطبيق تحذيرًا.

### أمثلة

- اختياري: المستخدم على build 10، واجعل `latest_android_build=11` و
  `minimum_android_build=10`.
- إجباري: المستخدم على build 10، واجعل القيمتين `latest_android_build=11`
  و`minimum_android_build=11`.
- إجبار القديم فقط: اجعل `latest_android_build=15` و
  `minimum_android_build=13`. تصبح 12 وما قبلها إجبارية، و13 و14 اختيارية،
  و15 بلا تحديث.

لإيقاف النظام فورًا اجعل `update_enabled=false`.

## مكان البوابة

`AppUpdateGate` مسجل في المسار `/` داخل `AppRoot`، ويحيط بالصفحة الأولى
الحالية (Onboarding أو شريط التنقل). لذلك يتم الفحص بعد Firebase وقبل السماح
بالوصول إلى الواجهة الأساسية، من دون إنشاء `MaterialApp` إضافي.

## الاختبار على Google Play

1. ارفع Android App Bundle يحمل `versionCode` أعلى إلى Internal Testing أو
   Internal App Sharing.
2. ثبّت إصدارًا أقدم من رابط Google Play نفسه، بالحساب المضاف إلى قائمة
   المختبرين.
3. انشر قيم Remote Config المناسبة وانتظر تفعيلها، ثم افتح الإصدار القديم.
4. اختبر الاختياري، الإجباري، إلغاء العملية، غياب الشبكة، والعودة من المتجر.
5. غيّر build المستخدم في كل تجربة؛ Google Play لن يعرض تحديثًا إذا لم يوجد
   إصدار أعلى متاح للحساب والجهاز.

Google Play In-App Updates لا تعمل عادةً مع `flutter run` أو APK مثبت يدويًا،
لأن التثبيت يجب أن يكون مملوكًا لـGoogle Play وبالتوقيع نفسه. عند عدم توفر
الـAPI يستخدم النظام رابط المتجر الاحتياطي.
