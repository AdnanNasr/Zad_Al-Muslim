# زاد المسلم - Zad Al-Muslim

<div align="center">

![Noor Bayan Logo](assets/images/app_logo.png)

### تطبيق إسلامي شامل مطور بأحدث التقنيات 🕌
### A Comprehensive Islamic App Built with Modern Tech 🌟

[![Flutter](https://img.shields.io/badge/Flutter-3.9-blue?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9-blue?style=for-the-badge&logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS-brightgreen?style=for-the-badge)](https://flutter.dev)

[نسخة عربية](#الوصف-العربي) • [English Version](#english-description)

</div>

---

## 🌍 الوصف العربي

**زاد المسلم** هو رفيقك المسلم اليومي المتكامل. تم تطويره باستخدام إطار العمل **Flutter** وباتباع منهجية **المعمارية النظيفة (Clean Architecture)** لضمان الأداء العالي، الاستدامة، وسهولة التوسع. يوفر التطبيق تجربة مستخدم فريدة تجمع بين جمال التصميم وعمق المحتوى.

### ✨ الميزات الرئيسية (من الألف إلى الياء)

#### 📖 القرآن الكريم (قراءة وتدبر)
*   **عرض فائق الجودة**: صفحات قرآنية واضحة جداً مأخوذة من مجمع الملك فهد.
*   **تخصيص كامل للخطوط**: اختر بين خط (Hafs) أو الخط العثماني (Naskh) بما يناسب بصرك.
*   **خلفيات القراءة الذكية**: أربعة أنماط مختلفة (أبيض، سبيا "ورقي"، ليلي، ورمادي) لراحة العين في كافة ظروف الإضاءة.
*   **البحث المتقدم**: محرك بحث سريع ودقيق في الآيات والسور.
*   **العلامات المرجعية**: حفظ آخر ما قرأت والرجوع إليه بلمسة واحدة.
*   **التفسير المتكامل**: تفسير الجلالين مدمج، مع إمكانية تحميل كتب تفسير إضافية من السحابة.

#### 🎙️ القرآن المرتل (الاستماع)
*   **نخبة القراء**: مكتبة واسعة تضم أشهر قراء العالم الإسلامي.
*   **الاستماع في الخلفية**: ميزة التشغيل المتواصل حتى عند إغلاق الشاشة.
*   **المزامنة التلقائية (Auto-Scroll)**: شاشة القراءة تتحرك تلقائياً مع تلاوة القارئ.
*   **إدارة التحميل**: نظام ذكي لإدارة الملفات الصوتية وتخزينها مؤقتاً (Cache) لتوفير البيانات.
*   **التحكم في الفواصل**: إمكانية إضافة تأخير زمني بين الآيات لأغراض الحفظ والتدبر.

#### 📚 الأحاديث النبوية
*   **صحيح البخاري**: قاعدة بيانات ضخمة تضم آلاف الأحاديث.
*   **البحث الذكي**: ميزة البحث بتجاهل التشكيل (Search Diacritic-Insensitive) لسهولة الوصول للحديث.
*   **المشاركة والنسخ**: سهولة نسخ الحديث أو مشاركته مع الآخرين.

#### 📿 الأذكار اليومية
*   **موسوعة الأذكار**: أذكار الصباح، المساء، الاستيقاظ، النوم، وغيرها الكثير.
*   **السبحة الإلكترونية**: عداد تفاعلي لكل ذكر مع اهتزاز بسيط عند الانتهاء.
*   **التوثيق والمراجع**: عرض المصدر لكل ذكر مع إمكانية نسخ المرجع.

#### 🕌 مواقيت الصلاة والقبلة
*   **دقة متناهية**: حساب المواقيت بناءً على موقعك الجغرافي باستخدام مكتبة (Adhan).
*   **العد التنازلي**: عرض الوقت المتبقي لأقرب صلاة بدقة.
*   **تنبيهات ذكية**: إشعارات لكل صلاة مع إمكانية التخصيص.
*   **القبلة التفاعلية**: بوصلة دقيقة مبنية على الخرائط (Map-based Compass) لتحديد الاتجاه في أي مكان.

#### ⚙️ الإعدادات والتخصيص
*   **نظام الألوان**: تخصيص لون التطبيق الأساسي بالكامل باستخدام (FlexColorScheme).
*   **اللغات**: دعم كامل للعربية، الإنجليزية، والألمانية.
*   **منع انطفاء الشاشة**: خيلار (Wake-lock) للحفاظ على الشاشة مفتوحة أثناء القراءة.

---

### 🏗️ المعمارية التقنية (Technical Architecture)

يتبع المشروع معمارية **Clean Architecture** لضمان فصل المهام (Separation of Concerns):

*   **Core**: يحتوي على المكونات المشتركة، الثوابت، قواعد البيانات، وإدارة المظاهر.
*   **Features**: كل ميزة (Quran, Hadith, etc.) مستقلة بذاتها وتتكون من:
    *   **Data**: النماذج (Models) ومصادر البيانات والمستودعات.
    *   **Domain**: الكيانات (Entities) وحالات الاستخدام (Use-cases).
    *   **Presentation**: واجهات المستخدم وإدارة الحالة (Riverpod).

### 🛠️ التقنيات المستخدمة (Tech Stack)

*   **Riverpod**: لإدارة الحالة (State Management) بشكل رد فعلي وقوي.
*   **Isar Database**: قاعدة بيانات NoSQL فائقة السرعة لتخزين الأذكار، الأحاديث، والمقالات.
*   **Just Audio**: لتجربة استماع احترافية وسلسة.
*   **Skeletonizer**: لتوفير واجهات تحميل (Shimmer) أنيقة وعصرية.
*   **Flex Color Scheme**: لإدارة السمات والألوان بشكل متطور.

---

### 🚀 التشغيل والتثبيت

1. تأكد من تثبيت **Flutter SDK** (الإصدار 3.9 فما فوق).
2. قم باستنساخ المشروع:
   ```bash
   git clone https://github.com/AdnanNasr/noor_bayan.git
   ```
3. تثبيت المكتبات:
   ```bash
   flutter pub get
   ```
4. توليد الكود (ضروري لقاعدة البيانات وRiverpod):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
5. التشغيل:
   ```bash
   flutter run
   ```

---

## 🌍 English Description

**Zad Al-Muslim** is an all-in-one Islamic companion app. Developed with **Flutter** using **Clean Architecture** principles, it ensures high performance, maintainability, and scalability. The app offers a unique user experience by blending visual beauty with deep spiritual content.

### ✨ Key Features (A to Z)

#### 📖 Holy Quran (Reading)
*   **Ultra High-Quality**: Crystal clear Quran pages from King Fahd Complex.
*   **Font Customization**: Choose between Hafs or Naskh (Uthmanic) fonts.
*   **Reading Backgrounds**: 4 themes (White, Sepia, Night, and Gray) for eye comfort.
*   **Advanced search**: Fast and accurate search across verses and surahs.
*   **Bookmarks**: Save your last read position and favorite verses.
*   **Integrated Tafseer**: Built-in Jalalayn, with the ability to download more from the cloud.

#### 🎙️ Quran Moratal (Audio)
*   **Top Reciters**: A wide library of the world's most famous reciters.
*   **Background Playback**: Keep listening even when the screen is off or app is minimized.
*   **Auto-Scroll**: The reading page automatically scrolls in sync with the recitation.
*   **Offline Support**: Smart caching system for audio files to save your data.
*   **Verse Delay**: Customizable interval between verses for memorization and reflection.

#### 📚 Prophetic Hadith
*   **Sahih Bukhari**: A massive database containing thousands of authentic hadith.
*   **Smart Search**: Diacritic-insensitive search for easy access.
*   **Share & Copy**: Share the sunnah easily with friends and family.

#### 📿 Daily Adkar
*   **Dhikr Encyclopedia**: Morning, Evening, Wake-up, Sleep adkar, and more.
*   **Digital Tasbih**: Interactive counter with haptic feedback.
*   **References**: View and copy the source/hadith for every dhikr.

#### 🕌 Prayer Times & Qibla
*   **Hyper-Accurate**: Calculations based on your GPS location using the (Adhan) library.
*   **Countdown**: Precise timer showing time remaining for the next prayer.
*   **Smart Alerts**: Customizable notifications for each prayer time.
*   **Map-based Qibla**: An interactive compass integrated with maps for worldwide accuracy.

#### ⚙️ Settings & Customization
*   **Theme Engine**: Fully customize the app colors using (FlexColorScheme).
*   **Multilingual**: Support for Arabic, English, and German.
*   **Screen Wake-lock**: Option to keep the screen on during extended reading sessions.

---

### 🎨 Design Philosophy
*   **Modern Aesthetics**: Premium UI with Glassmorphism and smooth animations.
*   **User Centric**: Responsive design that works perfectly on all screen sizes.
*   **Responsive State**: Using Skeletonizer for beautiful loading states.

---

<div align="center">

Made with ❤️ by Adnan

[⬆ Back to top](#نور-البيان---noor-bayan)

</div>
