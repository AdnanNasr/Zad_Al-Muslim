import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/constants/enums/my_enums.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/core/common/providers/language_provider.dart';

class LanguageDialog extends ConsumerStatefulWidget {
  final Function(AppLocale langCode)? onLanguageSelected;

  const LanguageDialog({super.key, this.onLanguageSelected});

  @override
  ConsumerState<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends ConsumerState<LanguageDialog> {
  final Map<AppLocale, String> langs = {
    AppLocale.ar: "العربية",
    AppLocale.en: "English",
    AppLocale.de: "Deutsch",
    //"ur": "اردو", 
    //"fr": "Français", 
    //"ms": "Bahasa Melayu",
    //"id": "Bahasa Indonesia",
    //"tr": "Türkçe",
};

  AppLocale get lang => ref.watch(languageProvider);
  AppLocale get _currentLangCode => lang;

  @override
  void initState() {
    super.initState();
  }

  void _selectLanguage(AppLocale langCode) {
    if (_currentLangCode != langCode) {
      ref.read(languageProvider.notifier).changeLanguage(appLocal: langCode);

      widget.onLanguageSelected?.call(langCode);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final List<AppLocale> langKeys = langs.keys.toList();

    return SimpleDialog(
      contentPadding: const EdgeInsets.all(16),
      titlePadding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              AppLocalizations.of(context)!.app_language,
              style: TextStyle(
                fontSize: context.witdthScreen * 0.06,
                fontFamily: "",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400, maxWidth: 350),
          child: SingleChildScrollView(
            child: ListBody(
              children: List.generate(langs.length, (index) {
                final AppLocale key = langKeys[index];
                final String value = langs[key]!;

                final bool isSelected = key == _currentLangCode;

                return Card(
                  child: ListTile(
                    title: Text(
                      value,
                      style: TextStyle(
                        fontSize: context.witdthScreen * 0.05,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w400,
                      ),
                    ),

                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,

                    onTap: () {
                      _selectLanguage(key);
                    },
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
