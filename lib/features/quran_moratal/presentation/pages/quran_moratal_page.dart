import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';
import 'package:zad_al_muslim/core/common/widgets/custom_app_bar.dart';
import 'package:zad_al_muslim/core/constants/enums/qari_names_moratal.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/pages/select_qari_surah_page.dart';

class QuranMoratalPage extends ConsumerWidget {
  const QuranMoratalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final bool isDark = themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: const CustomAppBar(
        title: "القرآن مُرتل",
        center: false,
        themeMode: false,
      ),
      body: AnimationLimiter(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          itemCount: QariNames.allQaris.length,

          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final Map<String, String> qariData = QariNames.allQaris[index];
            return AnimationConfiguration.staggeredList(
              duration: const Duration(milliseconds: 700),
              position: index,
              child: SlideAnimation(
                curve: Curves.linear,
                verticalOffset: 50,
                child: FadeInAnimation(
                  child: qariListTile(
                    qariData: qariData,
                    context: context,
                    isDark: isDark,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget qariListTile({
  required Map<String, String> qariData,
  required BuildContext context,
  required bool isDark,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SelectQariSurahPage(qariData: qariData),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Ink(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: context.color.primary.withValues(alpha: .3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 55.w,
              height: 55.w,
              decoration: BoxDecoration(
                color: isDark
                    ? context.color.primary.withValues(alpha: .7)
                    : context.color.primary.withValues(alpha: .1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.spatial_audio_off_rounded,
                  color: isDark
                      ? context.color.onSurface
                      : context.color.primary,
                ),
              ),
            ),
            SizedBox(width: 16.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    qariData["name"] ?? "",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Cairo",
                      color: isDark
                          ? context.color.onSurface
                          : context.color.onSurface,
                    ),
                  ),
                  Text(
                    "رواية حفص عن عاصم",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: "Cairo",
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? context.color.onSurface.withValues(alpha: .8)
                          : context.color.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isDark
                    ? context.color.primary.withValues(alpha: 0.7)
                    : context.color.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: isDark ? context.color.onSurface : context.color.primary,
                size: 24.sp,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
