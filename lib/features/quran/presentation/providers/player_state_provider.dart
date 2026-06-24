import 'package:flutter_riverpod/legacy.dart';

// --- معلومات الآية الحالية ---
class CurrentPlayingAyah {
  final int surahNumber;
  final int ayahNumber;
  final String surahName;

  CurrentPlayingAyah({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
  });
}

// مزود لتخزين الآية الحالية النشطة
final currentPlayingAyahProvider = StateProvider<CurrentPlayingAyah?>(
  (ref) => null,
);

// --- معلومات السورة المرتلة الحالية ---
class CurrentMoratalSurah {
  final int surahNumber;
  final String surahName;
  final String qariName;
  final String serverUrl;
  final String qariId;

  CurrentMoratalSurah({
    required this.surahNumber,
    required this.surahName,
    required this.qariName,
    required this.serverUrl,
    required this.qariId,
  });

  CurrentMoratalSurah copyWith({
    int? surahNumber,
    String? surahName,
    String? qariName,
    String? serverUrl,
    String? qariId,
  }) {
    return CurrentMoratalSurah(
      surahNumber: surahNumber ?? this.surahNumber,
      surahName: surahName ?? this.surahName,
      qariName: qariName ?? this.qariName,
      serverUrl: serverUrl ?? this.serverUrl,
      qariId: qariId ?? this.qariId,
    );
  }
}

// مزود لتخزين السورة المرتلة الحالية النشطة
final currentMoratalSurahProvider = StateProvider<CurrentMoratalSurah?>(
  (ref) => null,
);
