import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Noor Al-Bayan'**
  String get app_name;

  /// No description provided for @pray_times.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get pray_times;

  /// No description provided for @fajer.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajer;

  /// No description provided for @duhur.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get duhur;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @magrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get magrib;

  /// No description provided for @esha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get esha;

  /// No description provided for @main_categories.
  ///
  /// In en, this message translates to:
  /// **'Main Sections'**
  String get main_categories;

  /// No description provided for @quran_kareem.
  ///
  /// In en, this message translates to:
  /// **'Holy Quran'**
  String get quran_kareem;

  /// No description provided for @tafseer.
  ///
  /// In en, this message translates to:
  /// **'Tafsir'**
  String get tafseer;

  /// No description provided for @sunah.
  ///
  /// In en, this message translates to:
  /// **'Sunnah'**
  String get sunah;

  /// No description provided for @qebla_direction.
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get qebla_direction;

  /// No description provided for @adkar_adia.
  ///
  /// In en, this message translates to:
  /// **'Adhkar & Supplications'**
  String get adkar_adia;

  /// No description provided for @quran_reciters.
  ///
  /// In en, this message translates to:
  /// **'Reciters'**
  String get quran_reciters;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @updates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updates;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @reader_mishary_alafasy.
  ///
  /// In en, this message translates to:
  /// **'Mishary Alafasy'**
  String get reader_mishary_alafasy;

  /// No description provided for @reader_abdul_basit.
  ///
  /// In en, this message translates to:
  /// **'Abdul Basit Abdul Samad'**
  String get reader_abdul_basit;

  /// No description provided for @reader_mahmoud_alhusary.
  ///
  /// In en, this message translates to:
  /// **'Mahmoud Al-Husary'**
  String get reader_mahmoud_alhusary;

  /// No description provided for @reader_mustafa_ismail.
  ///
  /// In en, this message translates to:
  /// **'Mustafa Ismail'**
  String get reader_mustafa_ismail;

  /// No description provided for @reader_yasser_aldosari.
  ///
  /// In en, this message translates to:
  /// **'Yasser Al-Dosari'**
  String get reader_yasser_aldosari;

  /// No description provided for @reader_alsudais.
  ///
  /// In en, this message translates to:
  /// **'Abdul Rahman Al-Sudais'**
  String get reader_alsudais;

  /// No description provided for @reader_minshawi.
  ///
  /// In en, this message translates to:
  /// **'Mohamed Siddiq Al-Minshawi'**
  String get reader_minshawi;

  /// No description provided for @accoutn_settings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accoutn_settings;

  /// No description provided for @app_settings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get app_settings;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_information;

  /// No description provided for @payment_information.
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get payment_information;

  /// No description provided for @faviort.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get faviort;

  /// No description provided for @notifcations.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifcations;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @font_size.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get font_size;

  /// No description provided for @app_color.
  ///
  /// In en, this message translates to:
  /// **'App Color'**
  String get app_color;

  /// No description provided for @app_language.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get app_language;

  /// No description provided for @brandBlue.
  ///
  /// In en, this message translates to:
  /// **'Elegant'**
  String get brandBlue;

  /// No description provided for @blueWhale.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blueWhale;

  /// No description provided for @sakura.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get sakura;

  /// No description provided for @money.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get money;

  /// No description provided for @gold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get gold;

  /// No description provided for @vesuviusBurn.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get vesuviusBurn;

  /// No description provided for @barossa.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get barossa;

  /// No description provided for @shark.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get shark;

  /// No description provided for @controll_panel.
  ///
  /// In en, this message translates to:
  /// **'Control Panel'**
  String get controll_panel;

  /// No description provided for @last_reading.
  ///
  /// In en, this message translates to:
  /// **'Last Reading Position'**
  String get last_reading;

  /// No description provided for @search_in_quran.
  ///
  /// In en, this message translates to:
  /// **'Search in Quran'**
  String get search_in_quran;

  /// No description provided for @share_app.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get share_app;

  /// No description provided for @current_surah.
  ///
  /// In en, this message translates to:
  /// **'Current Surah'**
  String get current_surah;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @page_number.
  ///
  /// In en, this message translates to:
  /// **'Page Number'**
  String get page_number;

  /// No description provided for @select_surah.
  ///
  /// In en, this message translates to:
  /// **'Select Surah'**
  String get select_surah;

  /// No description provided for @search_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Search in the Holy Quran verses...'**
  String get search_placeholder;

  /// No description provided for @start_searching.
  ///
  /// In en, this message translates to:
  /// **'Start typing to search for verses'**
  String get start_searching;

  /// No description provided for @story.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get story;

  /// No description provided for @faviorte.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get faviorte;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @saved_bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Saved Bookmarks'**
  String get saved_bookmarks;

  /// No description provided for @save_reading_place.
  ///
  /// In en, this message translates to:
  /// **'Save reading position'**
  String get save_reading_place;

  /// No description provided for @mark_removed.
  ///
  /// In en, this message translates to:
  /// **'Bookmark removed'**
  String get mark_removed;

  /// No description provided for @mark_added.
  ///
  /// In en, this message translates to:
  /// **'Bookmark added'**
  String get mark_added;

  /// No description provided for @more_options.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get more_options;

  /// No description provided for @go_back.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get go_back;

  /// No description provided for @app_information.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get app_information;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @terms_of_use.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get terms_of_use;

  /// No description provided for @app_certificates.
  ///
  /// In en, this message translates to:
  /// **'App Certificates'**
  String get app_certificates;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @last_reading_surah.
  ///
  /// In en, this message translates to:
  /// **'Last Reading'**
  String get last_reading_surah;

  /// No description provided for @today_duaa.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Supplication'**
  String get today_duaa;

  /// No description provided for @show_all.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get show_all;

  /// No description provided for @sunah_hadeth.
  ///
  /// In en, this message translates to:
  /// **'Hadith and Sunnah'**
  String get sunah_hadeth;

  /// No description provided for @sahih_bukhari.
  ///
  /// In en, this message translates to:
  /// **'Sahih al-Bukhari'**
  String get sahih_bukhari;

  /// No description provided for @sahih_muslim.
  ///
  /// In en, this message translates to:
  /// **'Sahih Muslim'**
  String get sahih_muslim;

  /// No description provided for @sunan_abi_dawud.
  ///
  /// In en, this message translates to:
  /// **'Sunan Abi Dawud'**
  String get sunan_abi_dawud;

  /// No description provided for @sunan_at_tirmidhi.
  ///
  /// In en, this message translates to:
  /// **'Sunan at-Tirmidhi'**
  String get sunan_at_tirmidhi;

  /// No description provided for @sunan_an_nasai.
  ///
  /// In en, this message translates to:
  /// **'Sunan an-Nasa\'i'**
  String get sunan_an_nasai;

  /// No description provided for @sunan_ibn_majah.
  ///
  /// In en, this message translates to:
  /// **'Sunan Ibn Majah'**
  String get sunan_ibn_majah;

  /// No description provided for @time_format.
  ///
  /// In en, this message translates to:
  /// **'Time Format'**
  String get time_format;

  /// No description provided for @active_24_format.
  ///
  /// In en, this message translates to:
  /// **'24-hour format'**
  String get active_24_format;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'close'**
  String get close;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
