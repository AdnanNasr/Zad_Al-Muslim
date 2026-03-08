import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/view_models/providers/hadith_provider.dart';
import 'package:noor_quran/views/widgets/custom_app_bar.dart';
import 'package:noor_quran/views/widgets/tabs/featured_hadith_tab.dart';
import 'package:noor_quran/views/widgets/tabs/hadeeth_tab.dart';

class HadithPage extends ConsumerStatefulWidget {
  const HadithPage({super.key});

  @override
  ConsumerState<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends ConsumerState<HadithPage> {
  List<Widget> tabWidgets = [
    const Tab(child: Icon(Icons.my_library_books_rounded)),
    const Tab(child: Icon(Icons.favorite)),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          icon: Icons.arrow_back,
          customVoid: () => ref.read(hadithProvider.notifier).clearFilters(),
          title: AppLocalizations.of(context)!.sunah_hadeth,
          center: false,
          profile: false,
          bottom: TabBar(
            labelStyle: TextStyle(
              fontSize: context.witdthScreen * 0.045.sp,
              fontWeight: FontWeight.bold,
              fontFamily: "Cairo",
            ),
            indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
            labelColor: Theme.of(context).colorScheme.surface,
            unselectedLabelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelStyle: TextStyle(
              fontSize: context.witdthScreen * 0.045.sp,
              fontWeight: FontWeight.bold,
            ),
            tabs: tabWidgets,
          ),
        ),
        body: const TabBarView(children: [HadithTab(), FeaturedHadithsTab()]),
      ),
    );
  }
}
