<div align="center">
  <img src="assets/images/ic_launcher_foreground.png" alt="Zad Al-Muslim Logo" width="300"/>

  # Zad Al-Muslim (زاد المسلم)
  
  
  **تطبيق إسلامي شامل وعالي الأداء**

  
  **A Comprehensive, High-Performance Islamic Application**

  [![Flutter](https://img.shields.io/badge/Flutter-3.9-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.9-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![Clean Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-FF9900?style=for-the-badge)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
  [![State Management](https://img.shields.io/badge/State-Riverpod-005571?style=for-the-badge)](https://riverpod.dev)
  [![License: MIT](https://img.shields.io/badge/License-MIT-success?style=for-the-badge)](https://opensource.org/licenses/MIT)

  [العربية](#-النسخة-العربية) | [English](#-english-documentation)
</div>

---

## 🌍 النسخة العربية

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
   git clone https://github.com/AdnanNasr/noor_bayan.git
   cd noor_bayan
   ```
2. **جلب الاعتماديات**
   ```bash
   flutter pub get
   ```
3. **توليد الأكواد (Riverpod & Isar)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. **تشغيل التطبيق**
   ```bash
   flutter run
   ```

---

## 📖 English Documentation

### 🚀 Overview
**Zad Al-Muslim** is an enterprise-grade Islamic utility application crafted with a strict adherence to modern software engineering principles. Built on the Flutter framework, the application utilizes **Clean Architecture** to ensure modularity, scalability, and extreme testability. It serves as an all-encompassing digital companion for Muslims, delivering features such as Quran reading, audio recitations, Hadith databases, prayer times, Qibla direction, and daily Adkar.

### 🏗 Architecture & Engineering
This project was developed with a focus on long-term maintainability. It heavily enforces **Separation of Concerns (SoC)** by dividing the codebase into orthogonal layers:

- **Presentation Layer**: Built with Flutter and fully reactive using `Riverpod` for state management. Uses `Skeletonizer` for seamless loading states and `FlexColorScheme` for a dynamic, Material 3 compliant theming engine.
- **Domain Layer**: The core business logic, encapsulating `Entities`, `UseCases`, and Repository Interfaces. This layer is entirely pure Dart and framework-agnostic.
- **Infrastructure / Data Layer**: Implements repository contracts. Handles API networking via `Dio`, local NoSQL storage via `Isar Database`, and robust error handling using functional paradigms (e.g., `dartz` Either).
- **Core / DI**: Utilizes `GetIt` as a Service Locator for robust Dependency Injection, alongside centralized configuration, theming, and routing.

### ⚡ Technical Highlights
- **Isolate-Driven Indexing**: Employs background isolates (`QuranSearchIndexer`) to parse and index Quranic text without blocking the main UI thread, ensuring 60/120 FPS rendering during complex operations.
- **Advanced Audio Engine**: Integrates `just_audio` and `just_audio_background` to provide a robust background audio daemon with intelligent caching, auto-scrolling synchronization, and system media controls.
- **High-Performance Persistence**: Leverages `Isar Database` (C++ backed NoSQL) for instantaneous querying of tens of thousands of Hadiths and Adkar, utilizing composite indexes.
- **Geospatial Processing**: Offline prayer time calculation via mathematical astronomical algorithms (`Adhan` library) combined with geospatial mapping for Qibla direction.
- **Lifecycle Awareness**: Implements rigorous app lifecycle observers (`AppLifecycleObserver`) to manage memory constraints and background resource synchronization gracefully.

### ✨ Core Features
- **Holy Quran**: High-fidelity Uthmani typography, multi-theme reading modes (Sepia, Dark, Light), bookmarking, and integrated Jalalayn Tafseer.
- **Audio Recitations**: Background playback, verse-by-verse sync, gapless playback, and configurable inter-verse delays for memorization.
- **Hadith Library**: Comprehensive Sahih Bukhari integration with diacritic-insensitive search algorithms.
- **Daily Adkar**: Morning/evening supplications with a haptic-feedback digital Tasbih counter.
- **Prayer & Qibla**: Highly accurate localized prayer schedules with offline geocoding and a map-integrated compass.

### 🛠 Tech Stack
| Category | Libraries / Tools |
|---|---|
| **Core Framework** | Flutter 3.9, Dart 3.9 |
| **State & DI** | `flutter_riverpod`, `riverpod_annotation`, `get_it` |
| **Database** | `isar`, `isar_flutter_libs`, `shared_preferences` |
| **Networking** | `dio`, `internet_connection_checker_plus` |
| **Audio** | `just_audio`, `just_audio_background` |
| **Location & Math** | `geolocator`, `geocoding`, `adhan`, `flutter_compass` |
| **UI & Styling** | `flex_color_scheme`, `skeletonizer`, `flutter_screenutil` |
| **Background & Notifications**| `flutter_local_notifications`, `timezone`, `wakelock_plus` |

### 💻 Getting Started
#### Prerequisites
- Flutter SDK `^3.9.2`
- Android Studio / Xcode

#### Installation
1. **Clone the repository**
   ```bash
   git clone https://github.com/AdnanNasr/noor_bayan.git
   cd noor_bayan
   ```
2. **Fetch dependencies**
   ```bash
   flutter pub get
   ```
3. **Generate required code (Riverpod & Isar)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. **Run the application**
   ```bash
   flutter run
   ```

---
<div align="center">
  <sub>Developed with standard software engineering practices.</sub><br>
  <b>© 2026 Adnan Nasr</b>
</div>
