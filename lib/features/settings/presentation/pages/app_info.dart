import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/l10n/app_localizations.dart';
import 'package:zad_al_muslim/core/common/widgets/custom_app_bar.dart';
import 'package:zad_al_muslim/core/common/widgets/settings_card.dart';
import 'package:zad_al_muslim/features/settings/presentation/pages/custom_license_page.dart';
import 'package:zad_al_muslim/features/settings/presentation/pages/privcy_policy_page.dart';
import 'package:zad_al_muslim/features/settings/presentation/pages/terms_of_use_page.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              icon: const Right(Icons.lock),
              text: AppLocalizations.of(context)!.privacy_policy,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PrivcyPolicyPage(),
                ),
              ),
            ),
            SettingCards(
              icon: const Right(Icons.description),
              text: AppLocalizations.of(context)!.terms_of_use,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TermsOfUsePage()),
              ),
            ),
            SettingCards(
              icon: const Right(Icons.verified_user_outlined),
              text: AppLocalizations.of(context)!.app_certificates,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CustomLicensePage(),
                ),
              ),
            ),
            SettingCards(
              icon: const Right(Icons.numbers),
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
