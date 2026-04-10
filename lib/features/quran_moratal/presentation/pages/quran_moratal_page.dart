import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/core/constants/enums/qari_names_moratal.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/features/quran_moratal/presentation/pages/select_qari_surah_page.dart';

class QuranMoratalPage extends ConsumerWidget {
  const QuranMoratalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: "القرآن مُرتل",
        center: false,
        profile: false,
      ),
      body: AnimationLimiter(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          itemCount: QariNames.allQaris.length,

          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final Map<String, String> qariData = QariNames.allQaris[index];
            return AnimationConfiguration.staggeredList(
              duration: Duration(milliseconds: 700),
              position: index,
              child: SlideAnimation(
                curve: Curves.linear,
                verticalOffset: 50,
                child: FadeInAnimation(
                  child: qariListTile(
                    qariData: qariData,
                    context: context,
                    themeMode: themeMode,
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
  required ThemeMode themeMode,
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
                color: context.color.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.spatial_audio_off_rounded,
                  color: context.color.onPrimary,
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
                      color: context.color.primary,
                    ),
                  ),
                  Text(
                    "رواية حفص عن عاصم",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: "Cairo",
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: context.color.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: context.color.primary,
                size: 24.sp,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
