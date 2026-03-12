import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/features/quran/data/models/mark.dart';

import 'package:noor_quran/features/quran/presentation/providers/mark.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';
import 'package:noor_quran/core/common/widgets/home/home_button.dart';
import 'package:noor_quran/features/pray_time/presentation/widgets/pray_times_container.dart';
import 'package:noor_quran/features/quran/presentation/widgets/quran_page_app_bar.dart';

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
      body: SingleChildScrollView(
        child: BodyContent(
          colorScheme: colorScheme,
          themeMode: themeMode,
          lastReadingPostion: lastReadingPostion,
        ),
      ),
    );
  }
}

class BodyContent extends ConsumerWidget { // تم تحويله لـ ConsumerWidget لمراقبة الـ Providers
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
  Widget build(BuildContext context, WidgetRef ref) {
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
                    Expanded( // أضفت Expanded هنا ليعمل الـ Divider بشكل صحيح
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0.r, right: 8.r),
                        child: Divider(color: colorScheme.primary, thickness: 2),
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
                    
                    // --- زر مواقيت الصلاة ---
                    HomeButton(
                      text: AppLocalizations.of(context)!.pray_times,
                      iconImage: "assets/icons/mosque.png",
                      color: context.color.primary,
                      onTap: () {
                        Navigator.of(context).pushNamed("/pray_time_page");
                      },
                    ),
                    // ----------------------------


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
          // ... (كود الـ "آخر قراءة" يبقى كما هو) ...
          _buildLastReadingWidget(context, colorScheme, themeMode, lastReadingPostion!),
        
        SizedBox(height: 8.h),
        TodayDuaa(colorScheme: colorScheme, themeMode: themeMode),
      ],
    );
  }

  // دالة مساعدة لتنظيم كود الـ Last Reading
  Widget _buildLastReadingWidget(BuildContext context, ColorScheme colorScheme, ThemeMode themeMode, Mark lastReadingPostion) {
    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Material(
        surfaceTintColor: colorScheme.primary,
        shadowColor: themeMode == ThemeMode.light ? colorScheme.surface : colorScheme.primary,
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
                    style: TextStyle(fontSize: 20.sp, fontFamily: "Cairo", fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(child: Divider(thickness: 2, color: colorScheme.primary)),
              ],
            ),
            SizedBox(height: 8.h),
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => QuranPageAppBar(lastReadingPostion: lastReadingPostion.pageNumber),
              )),
              child: Ink(
                decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(6.r)),
                child: Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("سُورَةَ ${lastReadingPostion.surahName}", 
                               style: TextStyle(fontSize: 25.sp, fontFamily: "Amiri", color: colorScheme.onPrimary)),
                          SizedBox(width: 20.w),
                          Text("|", style: TextStyle(fontSize: 35.sp, color: colorScheme.onPrimary)),
                          SizedBox(width: 20.w),
                          Text("${AppLocalizations.of(context)!.page_number}: ${lastReadingPostion.pageNumber}",
                               style: TextStyle(fontSize: 18.sp, color: colorScheme.onPrimary)),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios, color: colorScheme.onPrimary),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodayDuaa extends StatelessWidget {
  const TodayDuaa({super.key, required this.colorScheme, required this.themeMode});
  final ColorScheme colorScheme;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return Material(
      surfaceTintColor: colorScheme.primary,
      shadowColor: themeMode == ThemeMode.light ? colorScheme.surface : colorScheme.primary,
      elevation: 2,
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(8.r),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Divider(thickness: 2.sp, color: colorScheme.primary)),
              Padding(
                padding: EdgeInsets.all(8.0.r),
                child: Text("دعاء اليوم", style: TextStyle(fontSize: 20.sp, fontFamily: "Cairo", fontWeight: FontWeight.bold)),
              ),
              Expanded(child: Divider(thickness: 2.sp, color: colorScheme.primary)),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Text(
              "كانَ رَسولُ اللَّهِ صَلَّى اللهُ عليه وسلَّمَ يَتَعَوَّذُ مِن جَهْدِ البَلَاءِ، ودَرَكِ الشَّقَاءِ، وسُوءِ القَضَاءِ، وشَمَاتَةِ الأعْدَاءِ",
              style: TextStyle(fontSize: 19.5.sp, fontFamily: "Tajawal", fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}