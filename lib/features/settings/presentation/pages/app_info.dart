import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/features/settings/presentation/widgets/settings_card.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: implement page
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.app_information,
        center: false,
        profile: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 8.0.h, right: 3.w, left: 3.w),
        child: Column(
          spacing: 10.h,
          children: [
            SettingCards(
              icon: Icons.lock,
              text: AppLocalizations.of(context)!.privacy_policy,
              onTap: () => debugPrint("Temp"),
            ),
            SettingCards(
              icon: Icons.description,
              text: AppLocalizations.of(context)!.terms_of_use,
              onTap: () => debugPrint("Temp"),
            ),
            SettingCards(
              icon: Icons.verified_user_outlined,
              text: AppLocalizations.of(context)!.app_certificates,
              onTap: () => debugPrint("Temp"),
            ),
            SettingCards(
              icon: Icons.info,
              text: AppLocalizations.of(context)!.version,
              widget: Text(
                "1.0.0",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Cairo",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
