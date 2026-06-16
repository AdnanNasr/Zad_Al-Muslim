import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:zad_al_muslim/core/constants/surah_names.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:zad_al_muslim/core/constants/enums/qrai_names_ayah_by_ayah.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/features/quran/domain/repositories/voice_ayah_by_ayah_repo.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/quran_settings_provider.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/voice_ayah_by_ayah_provider.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/player_state_provider.dart';
import 'package:zad_al_muslim/features/quran_moratal/data/services/moratal_download_service.dart';
import 'package:zad_al_muslim/core/utils/network/network_info.dart';
import 'package:qcf_quran/qcf_quran.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';

// مزود لتخزين القارئ المختار (يقرأ من الإعدادات المحفوظة)
final selectedQariProvider = Provider<QariModel>(
  (ref) => ref.watch(quranSettingsProvider).selectedQari,
);

// --- مزود مشغل الصوت العام (Global) ---
// يعمل هذا كمشغل وحيد للتطبيق لمنع تسريب الذاكرة (Memory Leak)
final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();

  player.playerStateStream.listen((state) {
    if (state.processingState == ProcessingState.completed) {
      if (player.loopMode == LoopMode.one) return;

      final currentAyah = ref.read(currentPlayingAyahProvider);
      if (currentAyah != null) {
        // التحقق من إعداد التمرير التلقائي (الانتقال للآية التالية)
        final autoScroll = ref.read(quranSettingsProvider).autoScrollWithAudio;
        if (!autoScroll) {
          ref.read(currentPlayingAyahProvider.notifier).state = null;
          return;
        }

        int nextAyah = currentAyah.ayahNumber + 1;
        int nextSurah = currentAyah.surahNumber;
        final verseCount = getVerseCount(nextSurah);

        if (nextAyah > verseCount) {
          if (nextSurah == 114) {
            if (player.loopMode == LoopMode.all) {
              nextSurah = 1;
              nextAyah = 1;
            } else {
              ref.read(currentPlayingAyahProvider.notifier).state = null;
              return;
            }
          } else {
            nextSurah += 1;
            nextAyah = 1;
          }
        }

        // إضافة الفاصل الزمني بناءً على إعدادات المستخدم
        final delaySeconds = ref.read(quranSettingsProvider).ayahDelaySeconds;
        if (delaySeconds > 0) {
          Future.delayed(Duration(seconds: delaySeconds), () {
            _playNextPreparedAyah(ref, player, nextSurah, nextAyah);
          });
        } else {
          _playNextPreparedAyah(ref, player, nextSurah, nextAyah);
        }
        return;
      }

      // التحقق من وجود سورة مرتلة قيد التشغيل
      final currentMoratal = ref.read(currentMoratalSurahProvider);
      if (currentMoratal != null) {
        if (player.loopMode == LoopMode.one) return;

        int nextSurah = currentMoratal.surahNumber + 1;
        if (nextSurah > 114) {
          if (player.loopMode == LoopMode.all) {
            nextSurah = 1;
          } else {
            ref.read(currentMoratalSurahProvider.notifier).state = null;
            return;
          }
        }

        // الانتقال للسورة التالية مع تأخير بسيط لضمان استقرار حالة المشغل
        Future.delayed(const Duration(milliseconds: 500), () {
          _playNextMoratalSurah(ref, currentMoratal, nextSurah);
        });
      }
    }
  });

  player.currentIndexStream.listen((index) {
    if (index == null) return;
    final sequence = player.sequence;
    if (index >= sequence.length) return;

    final activeSource = sequence[index];
    final tag = activeSource.tag;
    if (tag is MediaItem) {
      final parts = tag.id.split('_');
      if (parts.length >= 2) {
        final newSurahNumber = int.tryParse(parts.last);
        if (newSurahNumber != null) {
          final currentMoratal = ref.read(currentMoratalSurahProvider);
          if (currentMoratal != null && currentMoratal.surahNumber != newSurahNumber) {
            ref.read(currentMoratalSurahProvider.notifier).state = currentMoratal.copyWith(
              surahNumber: newSurahNumber,
              surahName: SurahNames.getFormattedName(newSurahNumber),
            );
          }
        }
      }
    }
  });

  ref.onDispose(() => player.dispose());
  return player;
});

// دالة مساعدة لتشغيل الآية التالية بعد الفاصل
void _playNextPreparedAyah(
  Ref ref,
  AudioPlayer player,
  int nextSurah,
  int nextAyah,
) {
  ref.read(currentPlayingAyahProvider.notifier).state = CurrentPlayingAyah(
    surahNumber: nextSurah,
    ayahNumber: nextAyah,
    surahName: SurahNames.getFormattedName(nextSurah),
  );
  final selectedQari = ref.read(selectedQariProvider);
  final urlEither = ref.read(
    voiceAyahByAyahProvider(
      AyahVoiceParameter(nextSurah, nextAyah, selectedQari),
    ),
  );
  urlEither.fold((failure) {}, (url) async {
    try {
      final bytes = await rootBundle.load('assets/images/logo.png');

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/app_logo_v2.png');

      await file.writeAsBytes(bytes.buffer.asUint8List());
      await player.setAudioSource(
        AudioSource.uri(
          Uri.parse(url),
          tag: MediaItem(
            id: 'ayah_${nextSurah}_$nextAyah',
            title: 'سورة ${SurahNames.getFormattedName(nextSurah)}',
            artist: 'الآية $nextAyah',
            artUri: file.uri,
          ),
        ),
      );
      player.play();
    } on PlayerInterruptedException {
      // تم إيقاف المشغل أثناء التحميل، لا داعي للقيام بأي شيء
    } catch (e) {
      // يمكن هنا إضافة تسجيل للخطأ إذا لزم الأمر
    }
  });
}

// دالة مساعدة لتشغيل السورة المرتلة التالية
void _playNextMoratalSurah(
  Ref ref,
  CurrentMoratalSurah current,
  int nextSurahNumber,
) {
  final nextSurah = current.copyWith(
    surahNumber: nextSurahNumber,
    surahName: SurahNames.getFormattedName(nextSurahNumber),
  );

  // استدعاء الأكشن لتشغيل السورة التالية
  ref.read(playMoratalSurahActionProvider)(nextSurah);
}

// مزود الأكشن لتشغيل سورة كاملة (Moratal) - يدعم التشغيل من الملف المحلي
final playMoratalSurahActionProvider = Provider((ref) {
  return (CurrentMoratalSurah surah) async {
    final audioPlayer = ref.read(audioPlayerProvider);

    // إيقاف أي تلاوة للأيات (Ayah-by-Ayah) لضمان عدم التداخل
    ref.read(currentPlayingAyahProvider.notifier).state = null;

    // تحديث حالة السورة المرتلة الحالية
    ref.read(currentMoratalSurahProvider.notifier).state = surah;

    final downloadService = sl<MoratalDownloadService>();
    final networkInfo = sl<NetworkInfo>();

    try {
      final bytes = await rootBundle.load('assets/images/logo.png');
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/app_logo_v2.png');
      if (!await file.exists()) {
        await file.writeAsBytes(bytes.buffer.asUint8List());
      }

      // تشغيل فحص الاتصال + فحص السور المحملة بشكل متوازٍ لتقليل وقت الانتظار
      final results = await Future.wait([
        networkInfo.hasValidConnection(),
        Future.wait(
          List.generate(114, (i) => downloadService.isSurahDownloaded(surah.qariId, i + 1)),
        ),
      ]);

      final isOnline = results[0] as bool;
      final checkedList = results[1] as List<bool>;
      final downloadedSurahs = [
        for (int i = 0; i < 114; i++)
          if (checkedList[i]) i + 1,
      ];

      final sequence = audioPlayer.sequence;
      bool isSamePlaylist = false;

      if (isOnline) {
        if (sequence.length == 114) {
          final firstSource = sequence.first;
          final tag = firstSource.tag;
          if (tag is MediaItem && tag.id.startsWith('${surah.qariId}_')) {
            isSamePlaylist = true;
          }
        }
      } else {
        if (sequence.length == downloadedSurahs.length && downloadedSurahs.isNotEmpty) {
          final firstSource = sequence.first;
          final tag = firstSource.tag;
          if (tag is MediaItem && tag.id.startsWith('${surah.qariId}_')) {
            isSamePlaylist = true;
          }
        }
      }

      if (isSamePlaylist) {
        // إذا كانت القائمة محملة مسبقاً، ننتقل مباشرة للفهرس المطلوب
        final targetIndex = isOnline
            ? surah.surahNumber - 1
            : downloadedSurahs.indexOf(surah.surahNumber);

        if (targetIndex != -1) {
          await audioPlayer.seek(Duration.zero, index: targetIndex);
          if (!audioPlayer.playing) {
            audioPlayer.play();
          }
        }
      } else {
        if (isOnline) {
          // بناء قائمة التشغيل لـ 114 سورة بشكل متوازي وسريع
          final sources = await Future.wait(
            List.generate(114, (i) async {
              final surahNumber = i + 1;
              final localPath = await downloadService.getSurahLocalPath(
                surah.qariId,
                surahNumber,
              );
              final isLocalAvailable = downloadedSurahs.contains(surahNumber);

              final mediaItem = MediaItem(
                id: '${surah.qariId}_$surahNumber',
                title: 'سورة ${SurahNames.getFormattedName(surahNumber)}',
                artist: surah.qariName,
                artUri: file.uri,
              );

              if (isLocalAvailable) {
                return AudioSource.file(localPath, tag: mediaItem);
              } else {
                final remoteUrl = '${surah.serverUrl}${surahNumber.toString().padLeft(3, "0")}.mp3';
                return AudioSource.uri(Uri.parse(remoteUrl), tag: mediaItem);
              }
            }),
          );

          await audioPlayer.setAudioSources(
            sources,
            initialIndex: surah.surahNumber - 1,
            initialPosition: Duration.zero,
          );
        } else {
          // في وضع عدم الاتصال، نبني قائمة تشغيل تحتوي فقط على السور المحملة
          if (!downloadedSurahs.contains(surah.surahNumber)) {
            downloadedSurahs.add(surah.surahNumber);
            downloadedSurahs.sort();
          }

          final sources = await Future.wait(
            downloadedSurahs.map((surahNumber) async {
              final localPath = await downloadService.getSurahLocalPath(
                surah.qariId,
                surahNumber,
              );
              final mediaItem = MediaItem(
                id: '${surah.qariId}_$surahNumber',
                title: 'سورة ${SurahNames.getFormattedName(surahNumber)}',
                artist: surah.qariName,
                artUri: file.uri,
              );
              return AudioSource.file(localPath, tag: mediaItem);
            }),
          );

          final targetIndex = downloadedSurahs.indexOf(surah.surahNumber);

          await audioPlayer.setAudioSources(
            sources,
            initialIndex: targetIndex != -1 ? targetIndex : 0,
            initialPosition: Duration.zero,
          );
        }

        final current = ref.read(currentMoratalSurahProvider);
        if (current != null &&
            current.surahNumber == surah.surahNumber &&
            current.qariId == surah.qariId) {
          audioPlayer.play();
        }
      }
    } on PlayerInterruptedException {
      // nothing will happen
    } on PlatformException catch (e) {
      final msg = e.message?.toLowerCase() ?? '';
      if (!msg.contains('abort') && !msg.contains('10000000')) {
        ref.read(currentMoratalSurahProvider.notifier).state = null;
      }
    } catch (e) {
      ref.read(currentMoratalSurahProvider.notifier).state = null;
    }
  };
});

// --- فئة مساعدة لدمج بيانات شريط التقدم ---
class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

// مزود لجلب بيانات الموضع المدمجة (Position, Buffered, Duration)
final audioPositionStreamProvider = Provider<Stream<PositionData>>((ref) {
  final player = ref.watch(audioPlayerProvider);
  return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
    player.positionStream,
    player.bufferedPositionStream,
    player.durationStream,
    (position, bufferedPosition, duration) =>
        PositionData(position, bufferedPosition, duration ?? Duration.zero),
  ).asBroadcastStream();
});
