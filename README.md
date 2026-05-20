<div align="center">
  <img src="assets/images/ic_launcher_foreground.png" alt="Zad Al-Muslim Logo" width="300"/>

  # Zad Al-Muslim (زاد المسلم)
  
  **تطبيق إسلامي شامل، عالي الأداء، ومفتوح المصدر (صدقة جارية)**
  
  **A Comprehensive, High-Performance, Open-Source Islamic Application (Sadakah Jariyah)**

  [![Flutter](https://img.shields.io/badge/Flutter-3.9-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.9-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![Clean Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-FF9900?style=for-the-badge)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
  [![State Management](https://img.shields.io/badge/State-Riverpod-005571?style=for-the-badge)](https://riverpod.dev)
  [![License: MIT](https://img.shields.io/badge/License-MIT-success?style=for-the-badge)](https://opensource.org/licenses/MIT)
  [![Sadakah Jariyah](https://img.shields.io/badge/Project-Sadakah__Jariyah-blueviolet?style=for-the-badge&logo=heart)](https://github.com/AdnanNasr/noor_bayan)

  [العربية](#-النسخة-العربية) | [English](#-english-documentation)
</div>

---

## 🌍 النسخة العربية

### 💝 صدقة جارية (وقف لله تعالى)
هذا المشروع تم بناؤه وتطويره بالكامل **لوجه الله تعالى**، ليكون **صدقة جارية** عني وعن والدي وعن كل من يساهم في نشره، تطويره، أو استخدامه لخدمة المسلمين. 
* **للمطورين:** يمكنك استخدام هذا الكود، التعديل عليه، بناء تطبيقاتك الخاصة بناءً عليه، أو الاستفادة من بنيته البرمجية بكل حرية بموجب رخصة MIT. 
* **نسألك الدعاء:** أقصى ما نرجوه منك عند الاستفادة من هذا المشروع هو دعوة بظهر الغيب لصاحب العمل ووالديه بالرحمة والمغفرة والتوفيق.

### 🚀 نظرة عامة
**زاد المسلم** هو تطبيق إسلامي متكامل تم بناؤه بمعايير هندسية احترافية ليقدم تجربة مستخدم خالية من العيوب وسريعة الاستجابة. يعتمد التطبيق على إطار عمل **Flutter** ويتبع منهجية **المعمارية النظيفة (Clean Architecture)**، مما يضمن أداءً فائقاً وقابلية عالية للصيانة والتطوير. يخدم التطبيق احتياجات المسلم اليومية من قراءة القرآن، الاستماع للتلاوات، تصفح الأحاديث، مواقيت الصلاة، تحديد القبلة، والأذكار.

### 🏗 المعمارية الهندسية
تم تصميم المشروع بالتركيز على استدامة الكود البرمجي (Long-term Maintainability) عبر تطبيق مبدأ **فصل المهام (Separation of Concerns)**:
- **طبقة العرض (Presentation)**: مبنية لتكون تفاعلية بالكامل باستخدام `Riverpod` لإدارة الحالة، مع دعم `Skeletonizer` لعرض حالات التحميل بسلاسة، و `FlexColorScheme` لإدارة المظاهر الديناميكية (Material 3).
- **طبقة المجال (Domain)**: تمثل قلب التطبيق وتحتوي على كيانات الأعمال (Entities) وحالات الاستخدام (UseCases). هذه الطبقة مجردة تماماً من أي اعتماديات خارجية أو إطارات عمل.
- **طبقة البنية التحتية (Infrastructure)**: تتعامل مع البيانات القادمة من الشبكة عبر `Dio` أو قاعدة البيانات المحلية فائقة السرعة `Isar`. يتم التعامل مع الأخطاء برمجياً بشكل وظيفي عبر (Functional Error Handling).
- **حقن الاعتماديات (DI)**: استخدام مكتبة `GetIt` لإدارة حقن الاعتماديات بكفاءة عالية مركزياً.

### ⚡ أبرز التقنيات
- **المعالجة في الخلفية (Isolates)**: معالجة نصوص القرآن وبناء فهارس البحث في مسارات خلفية (Background Isolates) لضمان عدم تأثر واجهة المستخدم (UI) والحفاظ على معدل 60 إطاراً في الثانية.
- **محرك صوتي متطور**: تكامل عميق مع `just_audio_background` لتشغيل التلاوات في الخلفية مع مزامنة التمرير التلقائي للآيات ودعم نظام التخزين المؤقت الذكي (Caching).
- **قواعد بيانات فائقة الأداء**: الاعتماد على محرك `Isar` (مبني على C++) لضمان استعلام لحظي من آلاف الأحاديث والأذكار باستخدام الفهارس المركبة (Composite Indexes).
- **خوارزميات فلكية وجغرافية**: حساب مواقيت الصلاة بدون إنترنت باستخدام معادلات فلكية دقيقة (`Adhan`) بالإضافة إلى بوصلة مكانية متكاملة لتحديد القبلة.
- **إدارة دورة حياة التطبيق (Lifecycle Awareness)**: تنفيذ مراقبات دقيقة لدورة حياة التطبيق (`AppLifecycleObserver`) لإدارة قيود الذاكرة ومزامنة الموارد في الخلفية بكفاءة.

### ✨ الميزات الأساسية
- **القرآن الكريم**: خط عثماني عالي الدقة، أوضاع قراءة متعددة (سبيا، ليلي، فاتح)، علامات مرجعية، وتفسير الجلالين المدمج.
- **التلاوات الصوتية**: تشغيل في الخلفية، مزامنة مع الآيات، تشغيل مستمر بدون انقطاع، وإمكانية تخصيص وقت التأخير بين الآيات لتسهيل الحفظ.
- **مكتبة الأحاديث**: دمج كامل لصحيح البخاري مع خوارزميات بحث ذكية تتجاهل التشكيل للوصول السريع.
- **الأذكار اليومية**: أذكار الصباح والمساء وغيرها مع مسبحة إلكترونية تفاعلية تدعم الاستجابة اللمسية (Haptic-feedback).
- **الصلاة والقبلة**: جداول أوقات صلاة محلية دقيقة جداً مع تحديد الموقع دون اتصال بالإنترنت وبوصلة مدمجة مع الخرائط.

### 🛠 التقنيات المستخدمة
| الفئة | المكتبات / الأدوات |
|---|---|
| **إطار العمل الأساسي** | Flutter 3.9, Dart 3.9 |
| **إدارة الحالة والحقن** | `flutter_riverpod`, `riverpod_annotation`, `get_it` |
| **قاعدة البيانات** | `isar`, `isar_flutter_libs`, `shared_preferences` |
| **الشبكة** | `dio`, `internet_connection_checker_plus` |
| **الصوتيات** | `just_audio`, `just_audio_background` |
| **الموقع والرياضيات** | `geolocator`, `geocoding`, `adhan`, `flutter_compass` |
| **واجهة المستخدم** | `flex_color_scheme`, `skeletonizer`, `flutter_screenutil` |
| **الخلفية والإشعارات**| `flutter_local_notifications`, `timezone`, `wakelock_plus` |

### 💻 دليل التشغيل
#### المتطلبات الأساسية
- Flutter SDK `^3.9.2`
- Android Studio / Xcode

#### التثبيت
1. **استنساخ المستودع**
   ```bash
   git clone [https://github.com/AdnanNasr/noor_bayan.git](https://github.com/AdnanNasr/noor_bayan.git)
   cd noor_bayan
