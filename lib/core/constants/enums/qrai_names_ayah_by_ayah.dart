// ? This file defines the Qari model and the data for Moratal Quran

/// الموديل الخاص بالقارئ لضمان الوصول للبيانات بشكل آمن (Type-Safe)
class QariModel {
  final String id;
  final String name;
  final String server;

  const QariModel({required this.id, required this.name, required this.server});

  // دالة مساعدة لتحويل الـ Map القديمة إلى Model إذا احتجت ذلك
  factory QariModel.fromMap(Map<String, String> map) {
    return QariModel(
      id: map["id"] ?? "",
      name: map["name"] ?? "",
      server: map["server"] ?? "",
    );
  }
}

class QariNamesAyahByAyah {
  static const QariModel masharyAlafassy = QariModel(
    id: "123",
    name: "مشاري العفاسي",
    server: "https://verse.mp3quran.net/arabic/mishary_alafasy/64/",
  );

  static const QariModel abdulBaset = QariModel(
    id: "51",
    name: "عبد الباسط عبد الصمد",
    server: "https://verse.mp3quran.net/arabic/abdulbasit_abdulsamad/128/",
  );

  static const QariModel alHossary = QariModel(
    id: "118",
    name: "محمود خليل الحصري",
    server: "https://verse.mp3quran.net/arabic/mahmood_alhusary/128/",
  );

  static const QariModel alMinshawi = QariModel(
    id: "112",
    name: "محمد صديق المنشاوي",
    server: "https://verse.mp3quran.net/arabic/mohammad_alminshawi/128/",
  );

  static const QariModel alMuaiqly = QariModel(
    id: "102",
    name: "ماهر المعيقلي",
    server: "https://verse.mp3quran.net/arabic/maher_almuaiqly/64/",
  );

  static const QariModel alSudais = QariModel(
    id: "54",
    name: "عبد الرحمن السديس",
    server: "https://verse.mp3quran.net/arabic/abdurrahmaan_alsudais/128/",
  );

  static const QariModel alShuraim = QariModel(
    id: "31",
    name: "سعود الشريم",
    server: "https://verse.mp3quran.net/arabic/saud_alshuraim/64/",
  );

  static const QariModel alAjmy = QariModel(
    id: "5",
    name: "أحمد بن علي العجمي",
    server: "https://verse.mp3quran.net/arabic/ahmed_alajmy/64/",
  );

  static const QariModel alDossari = QariModel(
    id: "92",
    name: "ياسر الدوسري",
    server: "https://verse.mp3quran.net/arabic/yasser_aldossary/64/",
  );

  // القائمة الكاملة باستخدام الموديل الجديد
  static const List<QariModel> allQaris = [
    masharyAlafassy,
    abdulBaset,
    alHossary,
    alMinshawi,
    alMuaiqly,
    alSudais,
    alShuraim,
    alAjmy,
    alDossari,
  ];
}
