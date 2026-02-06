class ReverseArabicNumbers {
   String convert(dynamic number) {
    if (number is int) {
      return number.toString();
    } else {
      String replace1 = number.replaceAll('٠', '0');
      String replace2 = replace1.replaceAll('١', '1');
      String replace3 = replace2.replaceAll('٢', '2');
      String replace4 = replace3.replaceAll('٣', '3');
      String replace5 = replace4.replaceAll('٤', '4');
      String replace6 = replace5.replaceAll('٥', '5');
      String replace7 = replace6.replaceAll('٦', '6');
      String replace8 = replace7.replaceAll('٧', '7');
      String replace9 = replace8.replaceAll('٨', '8');
      String replace10 = replace9.replaceAll('٩', '9');
      return replace10;
    }
  }
}