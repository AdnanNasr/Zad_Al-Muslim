import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/l10n/app_localizations.dart';
import 'package:zad_al_muslim/core/common/widgets/custom_app_bar.dart';
import 'package:zad_al_muslim/features/hadith/presentation/providers/hadith_provider.dart';
import 'package:zad_al_muslim/features/hadith/presentation/widgets/featured_hadith_tab.dart';
import 'package:zad_al_muslim/features/hadith/presentation/widgets/hadith_tab.dart';

class HadithPage extends ConsumerStatefulWidget {
  const HadithPage({super.key});

  @override
  ConsumerState<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends ConsumerState<HadithPage> {
  final List<Widget> screens = [const HadithTab(), const FeaturedHadithsTab()];

  int currentIndex = 0;

  void toggleIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          tooltip: "الصفحة الرئيسية",
          icon: Icons.arrow_back,
          customVoid: () async {
            await Future.delayed(const Duration(milliseconds: 50));
            if (!mounted) return;
            ref.read(hadithProvider.notifier).clearFilters();
          },
          title: l10n.sunah_hadeth,
          center: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70.h),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: context.color.primary.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  color: context.color.onPrimary,
                ),
                labelColor: context.color.primary,
                unselectedLabelColor: context.color.onPrimary,
                labelStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Cairo",
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: "Cairo",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(text: "الأحاديث"),
                  Tab(text: "المفضلات"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(children: screens),
      ),
    );
  }
}
