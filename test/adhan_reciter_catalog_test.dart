import 'package:flutter_test/flutter_test.dart';
import 'package:zad_al_muslim/features/adhan/data/reciter_catalog.dart';

void main() {
  test('every reciter has a paired normal and Fajr asset', () {
    for (final reciter in AdhanReciterCatalog.reciters) {
      expect(reciter.normalAsset, endsWith('${reciter.id}.mp3'));
      expect(reciter.fajrAsset, endsWith('${reciter.id}_fajr.mp3'));
      expect(reciter.assetFor(isFajr: true), reciter.fajrAsset);
      expect(reciter.assetFor(isFajr: false), reciter.normalAsset);
    }
  });
}
