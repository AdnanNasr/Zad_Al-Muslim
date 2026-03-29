import 'package:qcf_quran/qcf_quran.dart' as qcf;

String _robustNormalize(String input) {
  // إزالة التشكيل
  String clean = qcf.removeDiacritics(input);
  // توحيد الحروف للبحث المرن
  return clean
      .replaceAll(RegExp(r'[أإآا]'), 'ا') // توحيد الألف
      .replaceAll('ة', 'ه') // توحيد التاء المربوطة
      .replaceAll(RegExp(r'[يى]'), 'ى') // توحيد الياء والألف المقصورة
      .replaceAll('ؤ', 'و')
      .replaceAll('ئ', 'ي')
      .replaceAll(RegExp(r'\s+'), ' '); // إزالة المسافات المزدوجة
}

void main() {
  // Let's get "ذَٰلِكَ ٱلْكِتَـٰبُ" which is Ayah 2 of Al-Baqarah
  String ayahZalika = qcf.getVerse(2, 2, verseEndSymbol: false);
  print("Raw Ayah: \$ayahZalika");
  print("Removed Diacritics: \${qcf.removeDiacritics(ayahZalika)}");
  print("Normalized: \${_robustNormalize(ayahZalika)}");
  
  print("Query 'ذلك' normalized: \${_robustNormalize('ذلك')}");
  print("Contains 'ذلك'? \${_robustNormalize(ayahZalika).contains(_robustNormalize('ذلك'))}");
  
  // Let's get an ayah with "وإذ قال", like 2:30 (وَإِذْ قَالَ رَبُّكَ...)
  String ayahQala = qcf.getVerse(2, 30, verseEndSymbol: false);
  print("\\nRaw Ayah: \$ayahQala");
  print("Removed Diacritics: \${qcf.removeDiacritics(ayahQala)}");
  print("Normalized: \${_robustNormalize(ayahQala)}");
  
  print("Query 'واذ قال' normalized: \${_robustNormalize('واذ قال')}");
  print("Contains 'واذ قال'? \${_robustNormalize(ayahQala).contains(_robustNormalize('واذ قال'))}");

  // Output all char codes of _robustNormalize(ayahZalika) vs _robustNormalize('ذلك')
  print("\\nCodes of normalized target (first 5 chars):");
  for (var c in _robustNormalize(ayahZalika).runes.take(5)) {
    print("\\t\$c -> \${String.fromCharCode(c)}");
  }
}
