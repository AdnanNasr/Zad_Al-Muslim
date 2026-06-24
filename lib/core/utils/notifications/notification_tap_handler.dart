import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';
import 'package:zad_al_muslim/features/quran/data/models/mark.dart';
import 'package:zad_al_muslim/main.dart';
import 'package:zad_al_muslim/core/database/isar_db.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/quran_pages.dart';

class NotificationTapHandler {
  static Future<void> handle(String? payload) async {
    AppLogger.logger.e("Payload Status: $payload");
    if (payload == null || payload != 'quran_reading_reminder') return;

    int page = 1;

    try {
      final db = IsarDb.database;
      if (db != null) {
        final marks = await db.marks.where().sortByPageNumberDesc().findFirst();
        if (marks != null) {
          page = marks.pageNumber;
        }
      }
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 300));

    appNavigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => QuranPages(pageNumber: page)),
    );
  }
}
