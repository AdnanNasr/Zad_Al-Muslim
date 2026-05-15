import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zad_al_muslim/features/quran/data/models/mark.dart';
import 'package:zad_al_muslim/main.dart';
import 'package:zad_al_muslim/core/database/isar_db.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/quran_pages.dart';

class NotificationTapHandler {
  static Future<void> handle(String? payload) async {
    if (payload != 'quran_reading_reminder') return;

    int page = 1;

    try {
      final db = IsarDb.database;
      if (db != null) {
        final marks = await db.marks.where().findAll();
        if (marks.isNotEmpty) {
          page = marks.last.pageNumber;
        }
      }
    } catch (_) {}

    while (appNavigatorKey.currentState == null) {
      await Future.delayed(const Duration(milliseconds: 150));
    }

    appNavigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => QuranPages(pageNumber: page)),
    );
  }
}
