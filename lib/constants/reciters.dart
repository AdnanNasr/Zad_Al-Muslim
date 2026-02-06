import 'package:flutter/material.dart';
import 'package:noor_quran/l10n/app_localizations.dart';

extension Reciters on BuildContext{
  Map<String, String>  get qariData => {
    AppLocalizations.of(this)!.reader_mishary_alafasy:
        "assets/images/afasi.png",
    AppLocalizations.of(this)!.reader_abdul_basit:
        "assets/images/abdul_basit.jpg",
    AppLocalizations.of(this)!.reader_mahmoud_alhusary:
        "assets/images/al_husary.jpg",
    AppLocalizations.of(this)!.reader_mustafa_ismail:
        "assets/images/mustafa_ismail.jpg",
    AppLocalizations.of(this)!.reader_yasser_aldosari:
        "assets/images/dosri.jpg",
    AppLocalizations.of(this)!.reader_alsudais:
        "assets/images/al_sudais.jpg",
    AppLocalizations.of(this)!.reader_minshawi: "assets/images/menshawy.png",
  };
}