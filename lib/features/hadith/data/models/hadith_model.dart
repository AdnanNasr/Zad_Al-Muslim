import 'package:isar/isar.dart';
import 'package:zad_al_muslim/features/hadith/data/models/reference_model.dart';
import 'package:zad_al_muslim/features/hadith/domain/entities/hadith_entity.dart';

part 'hadith_model.g.dart';

@collection
class Hadith {
  // Isar يحتاج معرف فريد
  Id id = Isar.autoIncrement;

  // استخدمنا الحقول مباشرة لضمان توافقها مع Isar
  String hadithnumber = '';
  String text = '';
  String textNormalized = '';
  late ReferenceModel reference;

  @Index()
  bool isFavorite = false;

  Hadith(); // مشيد فارغ لـ Isar

  Hadith.full({
    required this.hadithnumber,
    required this.reference,
    required this.text,
    required this.textNormalized,
    this.isFavorite = false,
  });

  factory Hadith.fromEntity(HadithEntity entity) {
    return Hadith.full(
      hadithnumber: entity.hadithnumber,
      text: entity.text,
      textNormalized: entity.textNormalized,
      reference: ReferenceModel.fromEntity(entity.reference),
      isFavorite: entity.isFavorite,
    )..id = entity.isarId == 0 ? Isar.autoIncrement : entity.isarId;
  }

  // دالة تحويل المودل إلى Entity لاستخدامه في الـ Domain Layer
  HadithEntity toEntity() {
    return HadithEntity(
      isarId: id,
      hadithnumber: hadithnumber,
      text: text,
      textNormalized: textNormalized,
      reference: Reference(
        book: reference.book ?? 0,
        hadith: reference.hadith ?? 0,
      ),
      isFavorite: isFavorite,
    );
  }

  factory Hadith.fromJson(Map<String, dynamic> json) {
    // hadithnumber يمكن أن يكون int أو double (مثل 402.2)
    // نحوّله إلى String للحفاظ على القيمة الأصلية
    final rawNum = json["hadithnumber"];
    final String numStr = (rawNum is double)
        ? rawNum.toString()
        : rawNum.toString();
    final textData = json["text"] as String;
    return Hadith.full(
      hadithnumber: numStr,
      text: textData,
      textNormalized: textData
          .replaceAll(RegExp(r'[\u064B-\u065F]'), '') // حذف التشكيل
          .replaceAll(RegExp(r'[أإآ]'), 'ا') // توحيد الألف
          .replaceAll(RegExp(r'ة'), 'ه') // توحيد التاء
          .replaceAll(RegExp(r'ى'), 'ي'), // توحيد الياء
      // تأكد أن الـ JSON يحتوي على الخريطة الصحيحة للـ reference
      reference: ReferenceModel(
        book: json["reference"]["book"],
        hadith: json["reference"]["hadith"],
      ),
    );
  }
}
