import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/extensions/color_ext.dart';
import 'package:noor_quran/extensions/sizes_ext.dart';
import 'package:noor_quran/l10n/app_localizations.dart';
import 'package:noor_quran/view_models/models/db/islamic/mark.dart';
import 'package:noor_quran/view_models/providers/quran_providers/mark.dart';
import 'package:noor_quran/view_models/providers/theme_provider.dart';
import 'package:noor_quran/views/widgets/home_button.dart';
import 'package:noor_quran/views/widgets/pray_times_container.dart';
import 'package:noor_quran/views/widgets/quran_page_app_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeMode = ref.watch(themeProvider);
    final marksProvider = ref.watch(marksProvder);
    Mark? lastReadingPostion;

    if (marksProvider.isNotEmpty) {
      lastReadingPostion = marksProvider.last;
    }

    return Scaffold(
      body: lastReadingPostion != null
          ? SingleChildScrollView(
              child: BodyContent(
                colorScheme: colorScheme,
                themeMode: themeMode,
                lastReadingPostion: lastReadingPostion,
              ),
            )
          : BodyContent(
              colorScheme: colorScheme,
              themeMode: themeMode,
              lastReadingPostion: lastReadingPostion,
            ),
    );
  }
}

class BodyContent extends StatelessWidget {
  const BodyContent({
    super.key,
    required this.colorScheme,
    required this.themeMode,
    required this.lastReadingPostion,
  });

  final ColorScheme colorScheme;
  final ThemeMode themeMode;
  final Mark? lastReadingPostion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PrayTimesContainer(),
        Material(
          surfaceTintColor: colorScheme.primary,
          shadowColor: themeMode == ThemeMode.light
              ? colorScheme.surface
              : colorScheme.primary,
          elevation: 2,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
          color: colorScheme.surface,
          child: Column(
            children: [
              // TODO: fix spacing between components
              Padding(
                padding: EdgeInsets.only(top: 16.0.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(width: 6.w),
                    Text(
                      AppLocalizations.of(context)!.main_categories,
                      style: TextStyle(
                        height: 1.h,
                        fontSize: context.witdthScreen * 0.058.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Cairo",
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0.r, right: 8.r),
                        child: Divider(
                          color: colorScheme.primary,
                          thickness: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.only(bottom: 10.r, right: 10.r, left: 10.r),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 15,
                  children: [
                    HomeButton(
                      text: AppLocalizations.of(context)!.quran_kareem,
                      iconImage: "assets/icons/quran.png",
                      color: context.color.primary,
                      onTap: () {
                        Navigator.pushNamed(context, "/quran_pages");
                      },
                    ),
                    HomeButton(
                      text: AppLocalizations.of(context)!.tafseer,
                      iconImage: "assets/icons/book.png",
                      color: context.color.primary,
                      onTap: () {
                        Navigator.pushNamed(context, "/tafseer_page");
                      },
                    ),
                    HomeButton(
                      text: AppLocalizations.of(context)!.sunah,
                      iconImage: "assets/icons/quran2.png",
                      color: context.color.primary,
                      onTap: () {
                        Navigator.of(context).pushNamed("/sunah_page");
                      },
                    ),
                    HomeButton(
                      text: AppLocalizations.of(context)!.pray_times,
                      iconImage: "assets/icons/mosque.png",
                      color: context.color.primary,
                      onTap: () {
                        Navigator.of(context).pushNamed("/pray_time_page");
                      },
                    ),
                    HomeButton(
                      text: AppLocalizations.of(context)!.qebla_direction,
                      iconImage: "assets/icons/kaaba.png",
                      color: context.color.primary,
                      onTap: () {
                        Navigator.of(context).pushNamed("/qebla_page");
                      },
                    ),
                    HomeButton(
                      text: AppLocalizations.of(context)!.adkar_adia,
                      iconImage: "assets/icons/prayer.png",
                      color: context.color.primary,
                      onTap: () {
                        Navigator.of(context).pushNamed("/adkar_page");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 8.h),

        if (lastReadingPostion != null)
          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: Material(
              surfaceTintColor: colorScheme.primary,
              shadowColor: themeMode == ThemeMode.light
                  ? colorScheme.surface
                  : colorScheme.primary,
              elevation: 2,
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0.r),
                        child: Text(
                          AppLocalizations.of(context)!.last_reading_surah,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: "Cairo",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                          child: Divider(
                            thickness: 2,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.all(8.0.r),
                    child: InkWell(
                      splashColor: colorScheme.surface.withValues(alpha: .1),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return QuranPageAppBar(
                                lastReadingPostion:
                                    lastReadingPostion!.pageNumber,
                              );
                            },
                          ),
                        );
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0.r),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "سُورَةَ ${lastReadingPostion?.surahName}",
                                    style: TextStyle(
                                      fontSize: 25.sp,
                                      fontFamily: "Amiri",
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Text(
                                    "|",
                                    style: TextStyle(
                                      fontSize: 35.sp,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 35.w),
                                  Text(
                                    "${AppLocalizations.of(context)!.page_number}: ${lastReadingPostion?.pageNumber}",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: 8.h),

        lastReadingPostion == null
            ? Expanded(
                child: TodayDuaa(
                  colorScheme: colorScheme,
                  themeMode: themeMode,
                ),
              )
            : TodayDuaa(colorScheme: colorScheme, themeMode: themeMode),
      ],
    );
  }
}

class TodayDuaa extends StatelessWidget {
  const TodayDuaa({
    super.key,
    required this.colorScheme,
    required this.themeMode,
  });

  final ColorScheme colorScheme;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return Material(
      surfaceTintColor: colorScheme.primary,
      shadowColor: themeMode == ThemeMode.light
          ? colorScheme.surface
          : colorScheme.primary,
      elevation: 2,
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(8.r),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                  child: Divider(thickness: 2.sp, color: colorScheme.primary),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0.r),
                child: Text(
                  "دعاء اليوم",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                  child: Divider(thickness: 2.sp, color: colorScheme.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(8.0.r),
              child: Text(
                "كانَ رَسولُ اللَّهِ صَلَّى اللهُ عليه وسلَّمَ يَتَعَوَّذُ مِن جَهْدِ البَلَاءِ، ودَرَكِ الشَّقَاءِ، وسُوءِ القَضَاءِ، وشَمَاتَةِ الأعْدَاءِ",
                style: TextStyle(
                  fontSize: 19.5.sp,
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
