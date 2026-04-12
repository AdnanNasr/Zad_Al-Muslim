// App Locale
enum AppLocale { ar, en, de }

// Hadith Grade
// enum HadithGrade { sahih, hasan, daif }

// Netork info
enum NetworkInfoState { connected, loading, notConnected }

// Location States
enum LocationMessage {
  locationAllowed,
  locationDisabled,
  locationNotAllowed,
  locationNotAllowedEver,
  loading,
  error,
}

extension LocationMessageExtension on LocationMessage {
  static LocationMessage fromString(String status) {
    return LocationMessage.values.firstWhere(
      (e) => e.name == status,
      orElse: () => LocationMessage.error, // قيمة افتراضية في حال عدم المطابقة
    );
  }
}

// Hadith book names
enum SahihBukhariBook {
  revelation(1, "الوحي"),
  belief(2, "الإيمان"),
  knowledge(3, "العلم"),
  wudu(4, "الوضوء"),
  ghusl(5, "الغسل"),
  menstrualPeriods(6, "الحيض"),
  tayammum(7, "التيمم"),
  salat(8, "الصلاة"),
  prayerTimes(9, "مواقيت الصلاة"),
  adhaan(10, "الأذان"),
  fridayPrayer(11, "الجمعة"),
  fearPrayer(12, "صلاة الخوف"),
  eids(13, "العيدين"),
  witrPrayer(14, "الوتر"),
  istisqaa(15, "الاستسقاء"),
  eclipses(16, "الكسوف"),
  quranProstration(17, "سجود القرآن"),
  shorteningPrayers(18, "تقصير الصلاة"),
  tahajjud(19, "التهجد"),
  masjidVirtues(20, "فضل الصلاة في مكة والمدنية"),
  actionsInPrayer(21, "العمل في الصلاة"),
  forgetfulnessInPrayer(22, "السهو"),
  funerals(23, "الجنائز"),
  zakat(24, "الزكاة"),
  hajj(25, "الحج"),
  umrah(26, "العمرة"),
  pilgrimsPrevented(27, "المحصر"),
  huntingPenalty(28, "جزاء الصيد"),
  madinahVirtues(29, "فضائل المدينة"),
  fasting(30, "الصوم"),
  taraweeh(31, "صلاة التراويح"),
  laylatAlQadr(32, "فضل ليلة القدر"),
  itikaf(33, "الاعتكاف"),
  salesAndTrade(34, "البيوع"),
  asSalam(35, "السلم"),
  shufa(36, "الشفعة"),
  hiring(37, "الإجارة"),
  alHawaala(38, "الحوالة"),
  kafalah(39, "الكفالة"),
  proxyRepresentation(40, "الوكالة"),
  agriculture(41, "المزارعة"),
  waterDistribution(42, "المساقاة"),
  loansAndBankruptcy(43, "الاستقراض والديون والإفلاس"),
  khusoomaat(44, "الخصومات"),
  luqatah(45, "اللقطة"),
  oppressions(46, "المظالم"),
  partnership(47, "الشركة"),
  mortgaging(48, "الرهن"),
  manumission(49, "العتق"),
  makaatib(50, "المكاتب"),
  gifts(51, "الهبة"),
  witnesses(52, "الشهادات"),
  peacemaking(53, "الصلح"),
  conditions(54, "الشروط"),
  wills(55, "الوصايا"),
  jihad(56, "الجهاد والسير"),
  khumus(57, "الخمس"),
  jizyah(58, "الجزية والموادعة"),
  beginningOfCreation(59, "بدء الخلق"),
  prophets(60, "أحاديث الأنبياء"),
  prophetVirtues(61, "المناقب"),
  companions(62, "فضائل الصحابة"),
  ansaarVirtues(63, "مناقب الأنصار"),
  maghaazi(64, "المغازي"),
  tafseer(65, "التفسير"),
  quranVirtues(66, "فضائل القرآن"),
  nikaah(67, "النكاح"),
  divorce(68, "الطلاق"),
  familySupport(69, "النفقات"),
  food(70, "الأطعمة"),
  aqiqa(71, "العقيقة"),
  huntingSlaughtering(72, "الذبائح والصيد"),
  adaahi(73, "الأضاحي"),
  drinks(74, "الأشربة"),
  patients(75, "المرضى"),
  medicine(76, "الطب"),
  dress(77, "اللباس"),
  adab(78, "الأدب"),
  askingPermission(79, "الاستئذان"),
  invocations(80, "الدعوات"),
  riqaq(81, "الرقاق"),
  alQadar(82, "القدر"),
  oathsAndVows(83, "الأيمان والنذور"),
  oathsExpiation(84, "كفارة الأيمان"),
  alFaraid(85, "الفرائض"),
  hudood(86, "الحدود"),
  adDiyat(87, "الديات"),
  apostates(88, "استتابة المرتدين"),
  coercion(89, "الإكره"),
  tricks(90, "الحيل"),
  dreamInterpretation(91, "التعبير (تفسير الأحلام)"),
  afflictions(92, "الفتن"),
  ahkaam(93, "الأحكام"),
  wishes(94, "التمني"),
  truthfulInformation(95, "أخبار الآحاد"),
  holdingFast(96, "الاعتصام بالكتاب والسنة"),
  tawheel(97, "التوحيد");

  // تعريف الخصائص داخل الـ Enum في Dart
  final int id;
  final String arabicName;

  const SahihBukhariBook(this.id, this.arabicName);

  static SahihBukhariBook fromId(int id) {
    return SahihBukhariBook.values.firstWhere(
      (book) => book.id == id,
      orElse: () => SahihBukhariBook.revelation,
    );
  }

  static SahihBukhariBook fromEnglishName(String englishName) {
    return SahihBukhariBook.values.firstWhere(
      (book) => book.name == englishName,
      orElse: () => SahihBukhariBook.revelation,
    );
  }
}
