import 'package:zad_al_muslim/features/quran/domain/entities/voice_ayah_by_ayah_entity.dart';

class VoiceAyahByAyahModel extends VoiceAyahByAyahEntity {
  VoiceAyahByAyahModel({required super.url});

  VoiceAyahByAyahModel fromEntity({required String url}) {
    return VoiceAyahByAyahModel(url: url);
  }
}
