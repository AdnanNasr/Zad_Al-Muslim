import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:isar/isar.dart';
import 'package:noor_quran/core/constants/enums/my_enums.dart';
import 'package:noor_quran/view_models/models/db/islamic/hadith.dart';
import 'package:noor_quran/view_models/models/db/isar_db.dart';
import 'package:noor_quran/view_models/utils/app_logger.dart';

Future<void> insertHadithToIsar() async {
  final db = IsarDb.database;

  if (db == null) {
    AppLogger.logger.e("Error in Database; -> Null");
  }

  final content = await rootBundle.loadString("assets/json/hadith.json");
  final data = jsonDecode(content) as List;
  final existingHadith = await db!.hadiths.where().findAll();
  final existingHadithText = existingHadith.map((h) => h.hadith).toSet();

  await db.writeTxn(() async {
    for (final hadith in data) {
      final text = hadith["hadith"] ?? "";
      if (existingHadithText.contains(text)) continue;
      final hadithObj = Hadith()
        ..hadith = hadith["hadith"] ?? ""
        ..book = hadith["book"] ?? ""
        ..hadithNarrator = hadith["hadithNarrator"] ?? ""
        ..grade = parseHadithGrade(hadith["grade"])
        ..isFeautred = hadith["isFeautred"] ?? false
        ..topic = hadith["topic"] ?? "";

      await db.hadiths.put(hadithObj);
    }
    AppLogger.logger.i("تم اضافة الحديث الى قاعدة البيانات");
  });
}

HadithGrade parseHadithGrade(dynamic value) {
  if (value is! String) return HadithGrade.daif;
  return HadithGrade.values.firstWhere(
    (g) => g.name == value,
    orElse: () => HadithGrade.daif,
  );
}
