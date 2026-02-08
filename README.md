<div align="center"><h1>نور البيان - Noor Bayan<h1><div>

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.9-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9-blue?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS-brightgreen)

تطبيق قرآني متقدم | Advanced Quran Application

[نسخة عربية](#الوصف-العربي) • [English Version](#english-description)

</div>

---

## 🌍 الوصف العربي

### عن التطبيق

**نور البيان** هو تطبيق قرآني شامل مطور بـ Flutter، يوفر تجربة قراءة القرآن الكريم بطريقة حديثة وسلسة. يجمع التطبيق بين التكنولوجيا المتقدمة والتصميم الراقي لتقديم أفضل تجربة للمستخدم.

### ✨ المميزات الرئيسية

- 📖 **عرض القرآن الكريم** - عرض كامل سور القرآن الكريم بصيغة عالية الجودة
- 🔍 **خاصية البحث** - البحث في القرآن الكريم بسهولة
- 🌙 **المظهر المظلم** - دعم كامل للمظهر المظلم والفاتح
- 🎨 **تصميم احترافي** - واجهة مستخدم حديثة وسهلة الاستخدام
- 🌐 **دعم لغات متعددة** - العربية والإنجليزية والألمانية وغيرها
- 💾 **تخزين محلي** - حفظ التفضيلات والحفظيات
- ⚡ **أداء عالي** - تطبيق سريع وخفيف الوزن
- 📱 **متوافق مع جميع الأجهزة** - يعمل على Android و iOS

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

### 📁 هيكل المشروع

```
noor_bayan/
├── lib/
│   ├── main.dart              # نقطة البداية
│   ├── constants/             # الثوابت والمتغيرات الثابتة
│   │   ├── reciters.dart      # بيانات القارئين
│   │   ├── surahs.dart        # بيانات السور
│   │   └── enums/             # تعريفات Enum
│   ├── extensions/            # توسيعات مخصصة
│   │   ├── color_ext.dart
│   │   ├── sizes_ext.dart
│   │   ├── string_ext.dart
│   │   └── theme_ext.dart
│   ├── l10n/                  # ملفات التوطين (i18n)
│   │   └── app_*.arb          # ترجمات متعددة
│   ├── themes/                # تصميم المظهر
│   ├── utils/                 # دوال مساعدة
│   ├── view_models/           # منطق التطبيق
│   └── views/                 # الواجهات
├── assets/
│   ├── fonts/                 # الخطوط العربية المخصصة
│   │   ├── Amiri/
│   │   ├── Cairo/
│   │   ├── Tajawal/
│   │   └── Rubik/
│   ├── images/                # الصور
│   ├── icons/                 # الأيقونات
│   └── json/                  # ملفات JSON
├── android/                   # مشروع Android
├── ios/                       # مشروع iOS
├── pubspec.yaml               # ملف التبعيات
└── README.md                  # هذا الملف
```

### 🛠️ التكنولوجيات والمكتبات المستخدمة

#### إدارة الحالة

- **Flutter Riverpod** - إدارة حالة قوية وفعالة

#### قاعدة البيانات

- **Isar** - قاعدة بيانات محلية سريعة

#### التصميم والمظهر

- **Flex Color Scheme** - نظام ألوان مخصص
- **Flutter ScreenUtil** - استجابة حجم الشاشة

#### التوطين والترجمة

- **Intl** - دعم لغات متعددة
- **Flutter Localizations** - توطين محلي

#### أدوات أخرى

- **Dio** - للطلبات HTTP
- **Shared Preferences** - تخزين محلي
- **Flutter SVG** - دعم ملفات SVG
- **Logger** - تسجيل الأخطاء والعمليات

### 📝 كيفية المساهمة

نرحب بمساهماتك! اتبع الخطوات التالية:

1. اعمل Fork للمستودع
2. أنشئ فرع جديد (`git checkout -b feature/AmazingFeature`)
3. اقم بـ Commit للتغييرات (`git commit -m 'Add some AmazingFeature'`)
4. اضف فرعك (`git push origin feature/AmazingFeature`)
5. افتح Pull Request

### 📄 الترخيص

هذا المشروع مرخص تحت رخصة MIT - انظر ملف [LICENSE](LICENSE) للتفاصيل.

### 📞 التواصل

- **البريد الإلكتروني**: your.email@example.com
- **تويتر**: [@yourhandle](https://twitter.com/yourhandle)
- **الموقع**: [yourwebsite.com](https://yourwebsite.com)

### 🙏 شكر وتقدير

شكر خاص لجميع المساهمين والمطورين الذين ساهموا في هذا المشروع.

---

## 🌍 English Description

### About the Application

**Noor Bayan** is a comprehensive Quranic application developed with Flutter, providing a modern and seamless experience for reading the Holy Quran. The application combines advanced technology with elegant design to offer the best user experience.

### ✨ Key Features

- 📖 **Quran Display** - Complete display of all Quran chapters in high-quality format
- 🔍 **Search Functionality** - Search through the Quran easily
- 🌙 **Dark Mode** - Full support for dark and light themes
- 🎨 **Professional Design** - Modern and user-friendly interface
- 🌐 **Multi-Language Support** - Arabic, English, German, and more
- 💾 **Local Storage** - Save preferences and bookmarks
- ⚡ **High Performance** - Fast and lightweight application
- 📱 **Cross-Platform** - Works on Android and iOS

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
│   │   └── Rubik/
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
