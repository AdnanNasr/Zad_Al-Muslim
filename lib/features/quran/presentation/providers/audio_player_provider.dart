import 'package:noor_quran/core/common/constants/surah_names.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:noor_quran/core/constants/enums/qrai_names_ayah_by_ayah.dart';
import 'package:noor_quran/features/quran/domain/repositories/voice_ayah_by_ayah_repo.dart';
import 'package:noor_quran/features/quran/presentation/providers/quran_settings_provider.dart';
import 'package:noor_quran/features/quran/presentation/providers/voice_ayah_by_ayah_provider.dart';
import 'package:noor_quran/features/quran/presentation/providers/player_state_provider.dart';
import 'package:noor_quran/features/quran_moratal/domain/repositories/surah_qari_voice_repo.dart';
import 'package:noor_quran/features/quran_moratal/presentation/providers/surah_qari_voice_provider.dart';
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
      await player.setAudioSource(
        AudioSource.uri(
          Uri.parse(url),
          tag: MediaItem(
            id: 'ayah_${nextSurah}_$nextAyah',
            title: 'سورة ${SurahNames.getFormattedName(nextSurah)}',
            artist: 'الآية $nextAyah',
            // artUri: Uri.parse('asset:///assets/icons/moon.png'), // TODO: add app icon
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

// مزود الأكشن لتشغيل سورة كاملة (Moratal)
final playMoratalSurahActionProvider = Provider((ref) {
  return (CurrentMoratalSurah surah) async {
    final audioPlayer = ref.read(audioPlayerProvider);

    // إيقاف أي تلاوة للأيات (Ayah-by-Ayah) لضمان عدم التداخل
    ref.read(currentPlayingAyahProvider.notifier).state = null;

    // تحديث حالة السورة المرتلة الحالية
    ref.read(currentMoratalSurahProvider.notifier).state = surah;

    final params = QariParameters(
      serverUrl: surah.serverUrl,
      surahNumber: surah.surahNumber,
    );

    final urlEither = ref.read(surahQariVoiceProvider(params));

    await urlEither.fold(
      (failure) async {
        ref.read(currentMoratalSurahProvider.notifier).state = null;
      },
      (url) async {
        try {
          await audioPlayer.setAudioSource(
            AudioSource.uri(
              Uri.parse(url),
              tag: MediaItem(
                id: '${surah.qariId}_${surah.surahNumber}',
                title: 'سورة ${surah.surahName}',
                artist: surah.qariName,
              ),
            ),
            initialPosition: Duration.zero,
          );

          final current = ref.read(currentMoratalSurahProvider);
          if (current != null &&
              current.surahNumber == surah.surahNumber &&
              current.qariId == surah.qariId) {
            audioPlayer.play();
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
      },
    );
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

