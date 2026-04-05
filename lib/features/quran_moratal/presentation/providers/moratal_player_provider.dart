import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:noor_quran/features/quran/presentation/providers/audio_player_provider.dart';
import 'package:noor_quran/features/quran_moratal/presentation/providers/surah_qari_voice_provider.dart';
import 'package:noor_quran/features/quran_moratal/domain/repositories/surah_qari_voice_repo.dart';

// --- State Class for the Currently Playing Moratal Surah ---
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
}

// Provider to store the active Moratal Surah state
final currentMoratalSurahProvider = StateProvider<CurrentMoratalSurah?>(
  (ref) => null,
);

// Action provider to handle playing a full Surah for a specific Qari
final playMoratalSurahActionProvider = Provider((ref) {
  return (CurrentMoratalSurah surah) async {
    final audioPlayer = ref.read(audioPlayerProvider);

    // Stop any Ayah-by-Ayah playback to prevent conflicts
    ref.read(currentPlayingAyahProvider.notifier).state = null;

    // Set the new Moratal state
    ref.read(currentMoratalSurahProvider.notifier).state = surah;

    final params = QariParameters(
      serverUrl: surah.serverUrl,
      surahNumber: surah.surahNumber,
    );

    // Retrieve the URL
    final urlEither = ref.read(surahQariVoiceProvider(params));

    await urlEither.fold(
      (failure) async {
        // Handle failure if needed
        ref.read(currentMoratalSurahProvider.notifier).state = null;
      },
      (url) async {
        try {
          // Play the Surah
          await audioPlayer.setAudioSource(
            AudioSource.uri(
              Uri.parse(url),
              tag: MediaItem(
                id: '${surah.qariId}_${surah.surahNumber}',
                title: 'سورة ${surah.surahName}',
                artist: surah.qariName,
                artUri: Uri.parse(
                  'asset:///assets/icons/moon.png',
                ), // TODO: add app icon
              ),
            ),
          );
          audioPlayer.play();
        } catch (e) {
          ref.read(currentMoratalSurahProvider.notifier).state = null;
        }
      },
    );
  };
});
