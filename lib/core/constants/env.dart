class Env {
  // TODO: Change to server domain on Release
  // domain name must be the server domain
  // must be changed when the server is hosted
  // static String pingDomain = "google.com";

  //  pure api url
  static String baseUrl = "http://10.0.2.2:8000";

  // enpoint where App can get Tafsser from the server
  // TODO: change endpoint to domain server
  // current is local development ip
  static String tafseerEndpint = "";

  // this endpoint for quran ayah by ayah (quran page)
  static String voiceAyahByAyahBaseUrl = "https://verse.mp3quran.net/arabic";

  // this endpoint for quran moratal (full surah; quran moratal page)
  static const String baseQuranVoiceUrl = "https://server8.mp3quran.net";
}
