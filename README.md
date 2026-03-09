# نور البيان - Noor Bayan

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.9-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9-blue?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS-brightgreen)

تطبيق قرآني شامل | Comprehensive Islamic Application

[نسخة عربية](#الوصف-العربي) • [English Version](#english-description)

</div>

---

## 🌍 الوصف العربي

### عن التطبيق

**نور البيان** هو تطبيق إسلامي شامل مطور بـ Flutter باستخدام معمارية نظيفة (Clean Architecture)، يوفر مجموعة متكاملة من الميزات الإسلامية في تطبيق واحد. يجمع التطبيق بين التكنولوجيا المتقدمة والتصميم الراقي لتقديم أفضل تجربة للمستخدم المسلم.

### ✨ المميزات الرئيسية

#### 📖 القرآن الكريم

- عرض كامل لسور القرآن الكريم بصيغة عالية الجودة
- خاصية البحث المتقدم في الآيات والسور
- حفظ العلامات والإشارات المرجعية
- عرض التفسير للآيات

#### 📚 الأحاديث النبوية

- مجموعة شاملة من الأحاديث النبوية
- البحث في الأحاديث بسهولة
- تصنيف الأحاديث حسب الصحة والمصدر

#### 🕌 مواقيت الصلاة

- حساب دقيق لمواقيت الصلاة حسب الموقع الجغرافي
- تذكير بالصلاة عبر الإشعارات
- عرض الوقت المتبقي للصلاة التالية

#### 🧭 القبلة

- تحديد اتجاه القبلة بدقة باستخدام GPS
- عرض بصري للاتجاه مع الخريطة

#### 📿 الأذكار والأدعية

- مجموعة شاملة من الأذكار اليومية
- عداد الأذكار التفاعلي
- أذكار خاصة بكل وقت من اليوم

#### ⚙️ الإعدادات

- دعم كامل للمظهر المظلم والفاتح
- تخصيص ألوان التطبيق
- دعم لغات متعددة (العربية، الإنجليزية، الألمانية)
- إدارة الإشعارات والتذكيرات

### 🏗️ المعمارية التقنية

يستخدم التطبيق **معمارية نظيفة (Clean Architecture)** مع فصل واضح للمسؤوليات:

```
lib/
├── core/                    # الطبقة الأساسية
│   ├── common/             # المكونات المشتركة
│   ├── constants/          # الثوابت والمتغيرات الثابتة
│   ├── database/           # قاعدة البيانات (Isar)
│   ├── di/                 # Dependency Injection
│   ├── errors/             # إدارة الأخطاء
│   ├── extensions/         # توسيعات مخصصة
│   ├── l10n/               # التوطين والترجمة
│   ├── themes/             # إدارة المظاهر
│   └── utils/              # الأدوات المساعدة
├── features/               # الميزات المستقلة
│   ├── quran/              # قراءة القرآن
│   ├── hadith/             # الأحاديث النبوية
│   ├── pray_time/          # مواقيت الصلاة
│   ├── qebla/              # تحديد القبلة
│   ├── tafsser/            # التفسير
│   ├── adkar/              # الأذكار
│   └── settings/           # الإعدادات
└── main.dart               # نقطة البداية
```

### 🛠️ التكنولوجيات المستخدمة

#### إدارة الحالة

- **Flutter Riverpod** - إدارة حالة قوية وفعالة

#### قاعدة البيانات

- **Isar** - قاعدة بيانات محلية سريعة وموثوقة

#### الشبكة والطلبات

- **Dio** - مكتبة HTTP قوية للطلبات
- **Connectivity Plus** - مراقبة حالة الاتصال بالإنترنت

#### الموقع والخرائط

- **Geolocator** - تحديد الموقع الجغرافي
- **Geocoding** - تحويل الإحداثيات إلى عناوين
- **Adhan** - حساب مواقيت الصلاة بدقة

#### التصميم والواجهة

- **Flex Color Scheme** - نظام ألوان مخصص ومرن
- **Flutter ScreenUtil** - استجابة حجم الشاشة
- **Flutter SVG** - دعم ملفات SVG

#### الإشعارات والخدمات

- **Flutter Local Notifications** - إشعارات محلية
- **Flutter Native Splash** - شاشة البداية الأصلية
- **Shared Preferences** - تخزين البيانات البسيطة

#### أدوات التطوير

- **GetIt** - Dependency Injection
- **Dartz** - Functional Programming
- **Logger** - تسجيل الأحداث والأخطاء
- **Build Runner** - توليد الكود

### 📋 المتطلبات

- Flutter 3.9 أو أحدث
- Dart 3.9 أو أحدث
- Java 11 أو أحدث (لـ Android)
- Xcode 14 أو أحدث (لـ iOS)

### 🚀 التثبيت والتشغيل

#### 1. استنساخ المستودع

```bash
git clone https://github.com/your-username/noor_bayan.git
cd noor_bayan
```

#### 2. تثبيت المتطلبات

```bash
flutter pub get
flutter pub run build_runner build
```

#### 3. تشغيل التطبيق

```bash
# لـ Android
flutter run -d android

# لـ iOS
flutter run -d ios

# لكل الأجهزة
flutter run
```

### 📱 الميزات التقنية

- **معمارية نظيفة**: فصل واضح بين الطبقات والمسؤوليات
- **إدارة الحالة المتقدمة**: استخدام Riverpod لإدارة الحالة بكفاءة
- **قاعدة بيانات محلية**: تخزين البيانات محلياً باستخدام Isar
- **دعم كامل للغات**: العربية، الإنجليزية، والألمانية
- **تصميم متجاوب**: يعمل على جميع أحجام الشاشات
- **أداء عالي**: تحسينات للأداء والذاكرة
- **إشعارات ذكية**: تذكيرات الصلاة والأذكار
- **واجهة حديثة**: تصميم Material Design مع تخصيصات إسلامية

### 📝 كيفية المساهمة

نرحب بمساهماتك! اتبع الخطوات التالية:

1. اعمل Fork للمستودع
2. أنشئ فرع جديد (`git checkout -b feature/AmazingFeature`)
3. اقم بـ Commit للتغييرات (`git commit -m 'Add some AmazingFeature'`)
4. اضف فرعك (`git push origin feature/AmazingFeature`)
5. افتح Pull Request

### 📄 الترخيص

هذا المشروع مرخص تحت رخصة MIT - انظر ملف [LICENSE](LICENSE) للتفاصيل.

### 🙏 شكر وتقدير

شكر خاص لجميع المساهمين والمطورين الذين ساهموا في هذا المشروع.

---

## 🌍 English Description

### About the Application

**Noor Bayan** is a comprehensive Islamic application developed with Flutter using Clean Architecture, providing an integrated set of Islamic features in one application. The application combines advanced technology with elegant design to offer the best experience for Muslim users.

### ✨ Key Features

#### 📖 Holy Quran

- Complete display of all Quran chapters in high-quality format
- Advanced search functionality in verses and chapters
- Save bookmarks and references
- Display interpretation of verses

#### 📚 Hadith

- Comprehensive collection of prophetic hadith
- Easy search in hadith
- Classification of hadith by authenticity and source

#### 🕌 Prayer Times

- Accurate calculation of prayer times based on geographical location
- Prayer reminders via notifications
- Display remaining time for next prayer

#### 🧭 Qibla Direction

- Accurate determination of Qibla direction using GPS
- Visual display of direction with map

#### 📿 Dhikr and Prayers

- Comprehensive collection of daily dhikr
- Interactive dhikr counter
- Special dhikr for each time of day

#### ⚙️ Settings

- Full support for dark and light themes
- Customize application colors
- Multi-language support (Arabic, English, German)
- Manage notifications and reminders

### 🏗️ Technical Architecture

The application uses **Clean Architecture** with clear separation of responsibilities:

```
lib/
├── core/                    # Core layer
│   ├── common/             # Shared components
│   ├── constants/          # Constants and static variables
│   ├── database/           # Database (Isar)
│   ├── di/                 # Dependency Injection
│   ├── errors/             # Error handling
│   ├── extensions/         # Custom extensions
│   ├── l10n/               # Localization and translation
│   ├── themes/             # Theme management
│   └── utils/              # Helper utilities
├── features/               # Independent features
│   ├── quran/              # Quran reading
│   ├── hadith/             # Prophetic hadith
│   ├── pray_time/          # Prayer times
│   ├── qebla/              # Qibla direction
│   ├── tafsser/            # Interpretation
│   ├── adkar/              # Dhikr
│   └── settings/           # Settings
└── main.dart               # Entry point
```

### 🛠️ Technologies Used

#### State Management

- **Flutter Riverpod** - Powerful and efficient state management

#### Database

- **Isar** - Fast and reliable local database

#### Network & Requests

- **Dio** - Powerful HTTP library for requests
- **Connectivity Plus** - Monitor internet connection status

#### Location & Maps

- **Geolocator** - Geographical location determination
- **Geocoding** - Convert coordinates to addresses
- **Adhan** - Accurate prayer time calculation

#### Design & UI

- **Flex Color Scheme** - Custom and flexible color system
- **Flutter ScreenUtil** - Screen size responsiveness
- **Flutter SVG** - SVG file support

#### Notifications & Services

- **Flutter Local Notifications** - Local notifications
- **Flutter Native Splash** - Native splash screen
- **Shared Preferences** - Simple data storage

#### Development Tools

- **GetIt** - Dependency Injection
- **Dartz** - Functional Programming
- **Logger** - Event and error logging
- **Build Runner** - Code generation

### 📋 Requirements

- Flutter 3.9 or later
- Dart 3.9 or later
- Java 11 or later (for Android)
- Xcode 14 or later (for iOS)

### 🚀 Installation and Running

#### 1. Clone the Repository

```bash
git clone https://github.com/your-username/noor_bayan.git
cd noor_bayan
```

#### 2. Install Dependencies

```bash
flutter pub get
flutter pub run build_runner build
```

#### 3. Run the Application

```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For all devices
flutter run
```

### 📱 Technical Features

- **Clean Architecture**: Clear separation between layers and responsibilities
- **Advanced State Management**: Using Riverpod for efficient state management
- **Local Database**: Store data locally using Isar
- **Full Language Support**: Arabic, English, and German
- **Responsive Design**: Works on all screen sizes
- **High Performance**: Performance and memory optimizations
- **Smart Notifications**: Prayer and dhikr reminders
- **Modern Interface**: Material Design with Islamic customizations

### 📝 How to Contribute

We welcome your contributions! Follow these steps:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push your branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### 🙏 Acknowledgments

Special thanks to all contributors and developers who contributed to this project.

```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For all devices
flutter run
```

### 📁 Project Structure

```
noor_bayan/
├── lib/
│   ├── main.dart              # Entry point
│   ├── constants/             # Constants and static values
│   │   ├── reciters.dart      # Reciters data
│   │   ├── surahs.dart        # Chapters data
│   │   └── enums/             # Enum definitions
│   ├── extensions/            # Custom extensions
│   │   ├── color_ext.dart
│   │   ├── sizes_ext.dart
│   │   ├── string_ext.dart
│   │   └── theme_ext.dart
│   ├── l10n/                  # Localization files (i18n)
│   │   └── app_*.arb          # Multiple translations
│   ├── themes/                # Theme design
│   ├── utils/                 # Helper functions
│   ├── view_models/           # Business logic
│   └── views/                 # User interfaces
├── assets/
│   ├── fonts/                 # Custom Arabic fonts
│   │   ├── Amiri/
│   │   ├── Cairo/
│   │   ├── Tajawal/
│   ├── images/                # Images
│   ├── icons/                 # Icons
│   └── json/                  # JSON files
├── android/                   # Android project
├── ios/                       # iOS project
├── pubspec.yaml               # Dependencies file
└── README.md                  # This file
```

### 🛠️ Technologies and Libraries Used

#### State Management

- **Flutter Riverpod** - Powerful and efficient state management

#### Database

- **Isar** - Fast local database

#### Design and Theme

- **Flex Color Scheme** - Custom color system
- **Flutter ScreenUtil** - Responsive screen sizing

#### Localization and Translation

- **Intl** - Multi-language support
- **Flutter Localizations** - Local localization

#### Other Tools

- **Dio** - HTTP requests
- **Shared Preferences** - Local storage
- **Flutter SVG** - SVG file support
- **Logger** - Error and operation logging

### 📝 How to Contribute

We welcome your contributions! Follow these steps:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### 📞 Contact

- **Email**: your.email@example.com
- **Twitter**: [@yourhandle](https://twitter.com/yourhandle)
- **Website**: [yourwebsite.com](https://yourwebsite.com)

### 🙏 Acknowledgments

Special thanks to all contributors and developers who participated in this project.

---

<div align="center">

Made with ❤️ by Adnan

[⬆ Back to top](#نور-البيان---noor-bayan)

</div>
