class Env {
  // domain name must be the server domain
  // must be changed when the server is hosted

  static String androidAppLink =
      "https://play.google.com/store/apps/details?id=com.zad_al_muslim.adnan";
  static String iOSAppLink = "https://apps.apple.com/app/idXXXXXXXXXX";

  //  pure api url
  static String baseUrl = "https://adnandev.cloud";

  // enpoint where App can get Tafsser from the server
  static String tafseerEndpint = "https://adnandev.cloud/tafsser/tafsser_file";

  // this endpoint for quran ayah by ayah (quran page)
  static String voiceAyahByAyahBaseUrl = "https://verse.mp3quran.net/arabic";

  // this endpoint for quran moratal (full surah; quran moratal page)
  static const String baseQuranVoiceUrl = "https://server8.mp3quran.net";

  // this url host privcy policy link for the app
  static const String privcyPolicyUrl =
      "https://adnannasr.github.io/polices/privacy-policy.html";

  // this url host terms of use link for the app
  static const String termsOfuseUrl =
      "https://adnannasr.github.io/polices/terms-of-use.html";
}
