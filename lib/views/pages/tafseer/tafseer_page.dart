import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/extensions/color_ext.dart';
import 'package:noor_quran/extensions/theme_ext.dart';
import 'package:noor_quran/utils/testapi.dart';
import 'package:noor_quran/views/widgets/custom_app_bar.dart';
import 'package:noor_quran/views/widgets/tafseer_dialog.dart';
import 'package:noor_quran/views/widgets/tafsser_buttons.dart';

class TafseerPage extends ConsumerStatefulWidget {
  // TODO: when tafseer data are ready
  // جلب التفاسير
  const TafseerPage({super.key});

  @override
  ConsumerState<TafseerPage> createState() => _TafseerPageState();
}

class _TafseerPageState extends ConsumerState<TafseerPage> {
  final List<TafsserInfo> tafseerList = [
    TafsserInfo(
      name: "تفسير الجلالين",
      id: "jalalayn",
      description:
          "أشهر التفاسير المختصرة؛ يقدم شرحاً وجيزاً للآيات بأسلوب يسهل فهمه للمبتدئين، مع التركيز على المعنى المباشر للكلمات.",
    ),

    TafsserInfo(
      name: "تفسير القرطبي",
      id: "qurtubi",
      description:
          "مرجع جامع لأحكام القرآن؛ يركز على استنباط الأحكام الفقهية والمسائل الشرعية، مع عناية فائقة باللغة والقراءات القرآنية.",
    ),

    TafsserInfo(
      name: "تفسير البغوي",
      id: "baghawi",
      description:
          "يُعرف بـ 'تفسير أهل السنة'؛ يعتمد على النقل الصحيح عن السلف والصحابة، ويتميز بالبعد عن الإسرائيليات والأحاديث المنكرة.",
    ),

    TafsserInfo(
      name: "التفسير الميسر",
      id: "muyassar",
      description:
          "تفسير معاصر أعدته نخبة من العلماء؛ يتميز بعبارات سهلة ومنقحة، ومناسب جداً للقراءة السريعة والفهم الأولي لمعاني الآيات.",
    ),

    TafsserInfo(
      name: "التفسير الوسيط (طنطاوي)",
      id: "waseet",
      description:
          "تفسير يجمع بين التحليل اللفظي والبيان البلاغي؛ يتميز بأسلوبه الأدبي الرصين الذي يوضح المقاصد الكلية للسور بوضوح.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final themeMode = context.themeMode(ref);
    return Scaffold(
      backgroundColor: themeMode == ThemeMode.light
          ? context.color.onPrimary
          : context.color.scrim,
      appBar: const CustomAppBar(title: "تفسير", center: false, profile: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              itemCount: tafseerList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return TafsserItem(
                  info: tafseerList[index],
                  onPressed: () {
                    final String url =
                        "http://10.0.2.2:8000/tafsser_file/${tafseerList[index].id}";
                    downloadTafseer(url, tafseerList[index].name);
                  },
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return TafseerDialog(tafsserInfo: tafseerList[index]);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
