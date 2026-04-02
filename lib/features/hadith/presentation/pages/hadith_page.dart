import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/features/hadith/presentation/providers/hadith_provider.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/features/hadith/presentation/widgets/featured_hadith_tab.dart';
import 'package:noor_quran/features/hadith/presentation/widgets/hadeeth_tab.dart';

class HadithPage extends ConsumerStatefulWidget {
  const HadithPage({super.key});

  @override
  ConsumerState<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends ConsumerState<HadithPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          tooltip: "الصفحة الرئيسية",
          icon: Icons.arrow_back,
          customVoid: () => ref.read(hadithProvider.notifier).clearFilters(),
          title: l10n.sunah_hadeth,
          center: true,
          profile: false,
          bottom: TabBar(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            labelStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              fontFamily: "Cairo",
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              fontFamily: "Cairo",
            ),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            indicatorColor: Theme.of(context).colorScheme.onPrimary,
            labelColor: Theme.of(context).colorScheme.onPrimary,
            unselectedLabelColor: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.6),
            tabs: [
              Tab(
                text: l10n.books,
                icon: const Icon(Icons.my_library_books_rounded),
                iconMargin: EdgeInsets.only(bottom: 4.h),
              ),
              Tab(
                text: l10n.faviorte,
                icon: const Icon(Icons.favorite_rounded),
                iconMargin: EdgeInsets.only(bottom: 4.h),
              ),
            ],
          ),
        ),
        body: const TabBarView(children: [HadithTab(), FeaturedHadithsTab()]),
      ),
    );
  }
}
