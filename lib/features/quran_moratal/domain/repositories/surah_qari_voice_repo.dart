import 'package:dartz/dartz.dart';
import 'package:noor_quran/core/errors/failures.dart';

abstract class SurahQariVoiceRepo {
  Either<Failure, String> getSurahQariVoice(QariParameters qariParameters);
}

class QariParameters {
  final String serverUrl;
  final int surahNumber;
  QariParameters({required this.serverUrl, required this.surahNumber});
}
