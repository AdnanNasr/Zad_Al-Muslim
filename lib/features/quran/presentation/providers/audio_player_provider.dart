import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:noor_quran/core/constants/enums/qrai_names_ayah_by_ayah.dart';
import 'package:noor_quran/features/quran/domain/repositories/voice_ayah_by_ayah_repo.dart';
import 'package:noor_quran/features/quran/presentation/providers/voice_ayah_by_ayah_provider.dart';
import 'package:noor_quran/features/quran/presentation/providers/quran_settings_provider.dart';
import 'package:qcf_quran/qcf_quran.dart';
import 'package:rxdart/rxdart.dart';

// --- فئة لتخزين معلومات الآية الحالية ---
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
      if (currentAyah == null) return;

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
    }
  });

  ref.onDispose(() => player.dispose());
  return player;
});

// دالة مساعدة لتشغيل الآية التالية بعد الفاصل
void _playNextPreparedAyah(Ref ref, AudioPlayer player, int nextSurah, int nextAyah) {
      ref.read(currentPlayingAyahProvider.notifier).state = CurrentPlayingAyah(
        surahNumber: nextSurah,
        ayahNumber: nextAyah,
        surahName: getSurahNameArabic(nextSurah),
      );
      final selectedQari = ref.read(selectedQariProvider);
      final urlEither = ref.read(
        voiceAyahByAyahProvider(
          AyahVoiceParameter(
            nextSurah,
            nextAyah,
            selectedQari,
          ),
        ),
      );
      urlEither.fold((failure) {}, (url) async {
        try {
          await player.setAudioSource(
            AudioSource.uri(
              Uri.parse(url),
              tag: MediaItem(
                id: 'ayah_${nextSurah}_$nextAyah',
                title: 'سورة ${getSurahNameArabic(nextSurah)}',
                artist: 'الآية $nextAyah',
                artUri: Uri.parse('asset:///assets/icons/moon.png'),
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
