import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noor_quran/extensions/color_ext.dart';
import 'package:noor_quran/extensions/theme_ext.dart';
import 'package:noor_quran/utils/tafseer_utils.dart';
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

  // مراجع لكل عنصر TafsserItem
  late List<GlobalKey<TafsserItemState>> itemKeys;
  
  // قائمة بحفظ التفاسير المحملة
  late List<bool> downloadedList;
  
  // المفتاح المستخدم لحفظ البيانات في Shared Preferences
  static const String _downloadedTafseersKey = "downloaded_tafseer_list";

  @override
  void initState() {
    super.initState();
    itemKeys = List.generate(
      tafseerList.length,
      (index) => GlobalKey<TafsserItemState>(),
    );
    downloadedList = List<bool>.filled(tafseerList.length, false);
    _loadDownloadState();
    _loadActiveDownloads(); // تحميل التنزيلات الجارية
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // إعادة التحقق من حالة التنزيل عند العودة إلى الصفحة
    _refreshDownloadState();
    _resumePendingDownloads(); // استئناف التنزيلات المعلقة
  }

  Future<void> _loadActiveDownloads() async {
    // الحصول على التنزيلات الجارية المحفوظة
    final activeDownloads = await getActiveDownloads();
    
    if (mounted) {
      for (int i = 0; i < tafseerList.length; i++) {
        if (activeDownloads.containsKey(tafseerList[i].name)) {
          final downloadProgress = activeDownloads[tafseerList[i].name] ?? 0.0;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && itemKeys[i].currentState != null) {
              itemKeys[i].currentState?.setIsDownloading(true);
              itemKeys[i].currentState?.updateDownloadProgress(downloadProgress);
            }
          });
        }
      }
    }
  }

  Future<void> _loadDownloadState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(_downloadedTafseersKey) ?? [];
    
    setState(() {
      for (int i = 0; i < tafseerList.length; i++) {
        // التحقق من وجود اسم التفسير في القائمة المحفوظة
        if (savedList.contains(tafseerList[i].name)) {
          downloadedList[i] = true;
          // تحديث حالة الودجت لعرض الحالة الصحيحة
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && itemKeys[i].currentState != null) {
              itemKeys[i].currentState?.markAsDownloaded();
            }
          });
        }
      }
    });
  }

  Future<void> _refreshDownloadState() async {
    // التحقق من الملفات الفعلية على الجهاز والتنزيلات الجارية
    _loadDownloadState();
    _loadActiveDownloads();
  }

  Future<void> _resumePendingDownloads() async {
    // استئناف التنزيلات المعلقة عند العودة إلى الصفحة
    final pendingDownloads = await getPendingDownloads();
    
    for (final entry in pendingDownloads.entries) {
      final tafseerName = entry.key;
      final url = entry.value;
      
      // البحث عن الفهرس المطابق
      final index = tafseerList.indexWhere((t) => t.name == tafseerName);
      
      // إذا كان التفسير موجود ولم يتم تحميله بعد، استأنف التنزيل
      if (index != -1 && !downloadedList[index]) {
        _startDownload(index, url, tafseerName);
      }
    }
  }

  void _startDownload(int index, String url, String tafseerName) {
    // تعيين حالة التنزيل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && itemKeys[index].currentState != null) {
        itemKeys[index].currentState?.setIsDownloading(true);
      }
    });

    downloadTafseer(
      url,
      tafseerName,
      onProgress: (progress) {
        if (mounted) {
          itemKeys[index].currentState?.updateDownloadProgress(progress);
        }
      },
      onComplete: () {
        if (mounted) {
          itemKeys[index].currentState?.markAsDownloaded();
          _saveDownloadState(index);
          _showSuccessMessage(tafseerName);
          removePendingDownload(tafseerName); // إزالة من التنزيلات المعلقة
        }
      },
      onError: (errorMessage) {
        if (mounted) {
          itemKeys[index].currentState?.setIsDownloading(false);
          _showErrorMessage(errorMessage);
          removePendingDownload(tafseerName); // إزالة من التنزيلات المعلقة
        }
      },
    );
  }

  Future<void> _saveDownloadState(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(_downloadedTafseersKey) ?? [];
    
    // إضافة اسم التفسير إلى القائمة المحفوظة
    if (!savedList.contains(tafseerList[index].name)) {
      savedList.add(tafseerList[index].name);
      await prefs.setStringList(_downloadedTafseersKey, savedList);
    }
    
    setState(() {
      downloadedList[index] = true;
    });
  }

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
                  key: itemKeys[index],
                  info: tafseerList[index],
                  isDownloaded: downloadedList[index],
                  onPressed: () => _handleDownloadItem(index),
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

  void _handleDownloadItem(int index) {
    // تجنب البدء بتنزيل جديد إذا كان بالفعل محمل
    if (downloadedList[index]) {
      _showErrorMessage("تم تحميل هذا التفسير بالفعل");
      return;
    }

    final String url =
        "http://10.0.2.2:8000/tafsser_file/${tafseerList[index].id}";
    
    // حفظ معلومات التنزيل المعلقة
    addPendingDownload(tafseerList[index].name, url);
    
    // بدء التنزيل
    _startDownload(index, url, tafseerList[index].name);
  }

  void _showSuccessMessage(String tafseerName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "تم تحميل $tafseerName بنجاح ✓",
          style: TextStyle(
            fontFamily: "Rubik",
            fontSize: 14.sp,
          ),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          style: TextStyle(
            fontFamily: "Rubik",
            fontSize: 14.sp,
          ),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
