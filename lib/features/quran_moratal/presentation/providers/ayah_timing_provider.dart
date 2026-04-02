import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AyahTiming {
  final int ayah;
  final int startTime; // in milliseconds
  final int endTime; // in milliseconds

  AyahTiming({
    required this.ayah,
    required this.startTime,
    required this.endTime,
  });

  factory AyahTiming.fromJson(Map<String, dynamic> json) {
    return AyahTiming(
      ayah: json['ayah'] as int,
      startTime: json['start_time'] as int,
      endTime: json['end_time'] as int,
    );
  }
}

class AyahTimingParams {
  final int surahNumber;
  final String qariId;

  AyahTimingParams({required this.surahNumber, required this.qariId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AyahTimingParams &&
          runtimeType == other.runtimeType &&
          surahNumber == other.surahNumber &&
          qariId == other.qariId;

  @override
  int get hashCode => surahNumber.hashCode ^ qariId.hashCode;
}

final ayahTimingProvider =
    FutureProvider.family<List<AyahTiming>, AyahTimingParams>((
      ref,
      params,
    ) async {
      final dio = Dio();
      final response = await dio.get(
        'https://www.mp3quran.net/api/v3/ayat_timing',
        queryParameters: {'surah': params.surahNumber, 'read': params.qariId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => AyahTiming.fromJson(json))
            .where((e) => e.ayah != 0) // Filter out index 0 as it's not a valid verse
            .toList();
      } else {
        throw Exception('Failed to load ayah timing');
      }
    });

int? currentAyahFromTimings(List<AyahTiming> timings, Duration position) {
  if (timings.isEmpty) return null;
  final currentMs = position.inMilliseconds;

  for (final timing in timings) {
    if (currentMs >= timing.startTime && currentMs <= timing.endTime) {
      return timing.ayah;
    }
  }

  // If before the first recorded ayah, return the first one
  if (currentMs < timings.first.startTime) {
    return timings.first.ayah;
  }

  for (int i = 0; i < timings.length - 1; i++) {
    if (currentMs > timings[i].endTime &&
        currentMs < timings[i + 1].startTime) {
      return timings[i + 1].ayah;
    }
  }

  return null;
}
