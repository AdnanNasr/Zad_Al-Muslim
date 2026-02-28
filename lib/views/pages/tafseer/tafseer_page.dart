import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/extensions/color_ext.dart';
import 'package:noor_quran/extensions/theme_ext.dart';
import 'package:noor_quran/utils/network_info.dart';
import 'package:noor_quran/utils/tafsser/tafseer_utils.dart';
import 'package:noor_quran/view_models/providers/avalible_tafsser_books.dart';
import 'package:noor_quran/views/widgets/custom_app_bar.dart';
import 'package:noor_quran/views/widgets/tafseer_dialog.dart';
import 'package:noor_quran/views/widgets/tafsser_buttons.dart';

class TafseerPage extends ConsumerStatefulWidget {
  const TafseerPage({super.key});

  @override
  ConsumerState<TafseerPage> createState() => _TafseerPageState();
}

class _TafseerPageState extends ConsumerState<TafseerPage> {
  // قائمة التفاسير مع المعرفات (IDs) التي يجب أن تطابق الـ identifier في الـ JSON
  // ملاحظة: استخدم نفس الـ identifier المحفوظ في قاعدة البيانات (بـ dot بدلاً من underscore)
  final List<TafsserInfo> tafseerList = [
    TafsserInfo(
      name: "تفسير الجلالين",
      id: "ar.jalalayn",
      description:
          "أشهر التفاسير المختصرة؛ يقدم شرحاً وجيزاً للآيات بأسلوب يسهل فهمه للمبتدئين.",
    ),
    TafsserInfo(
      name: "تفسير القرطبي",
      id: "ar.qurtubi",
      description:
          "مرجع جامع لأحكام القرآن؛ يركز على استنباط الأحكام الفقهية والمسائل الشرعية.",
    ),
    TafsserInfo(
      name: "تفسير البغوي",
      id: "ar.baghawi",
      description:
          "يُعرف بـ 'تفسير أهل السنة'؛ يعتمد على النقل الصحيح عن السلف والصحابة.",
    ),
    TafsserInfo(
      name: "التفسير الميسر",
      id: "ar.muyassar",
      description:
          "تفسير معاصر أعدته نخبة من العلماء؛ يتميز بعبارات سهلة ومنقحة ومناسبة جداً.",
    ),
    TafsserInfo(
      name: "التفسير الوسيط",
      id: "ar.waseet",
      description:
          "تفسير يجمع بين التحليل اللفظي والبيان البلاغي؛ يتميز بأسلوبه الأدبي الرصين.",
    ),
  ];

  late List<GlobalKey<TafsserItemState>> itemKeys;
  late List<bool> downloadedList;

  @override
  void initState() {
    super.initState();
    itemKeys = List.generate(
      tafseerList.length,
      (index) => GlobalKey<TafsserItemState>(),
    );
    downloadedList = List<bool>.filled(tafseerList.length, false);
    
    // استدعِ _initialSetup بعد بناء الـ widget بشكل كامل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialSetup();
    });
  }

  Future<void> _initialSetup() async {
    await _refreshDownloadState(); // التحقق من Isar
    await _loadActiveDownloads(); // التنزيلات الجارية
    await _resumePendingDownloads(); // استئناف المعلق
  }

  // تحديث الحالة بناءً على وجود البيانات في Isar فعلياً
  Future<void> _refreshDownloadState() async {
    for (int i = 0; i < tafseerList.length; i++) {
      bool isExist = await TafseerUtils.isTafseerDownloaded(tafseerList[i].id);
      if (mounted) {
        // تحديث حالة التحميل في الـ state
        setState(() {
          downloadedList[i] = isExist;
        });
        
        // إذا كان التفسير محملاً، مسح أي بيانات تحميل قديمة
        if (isExist) {
          final tafseerId = tafseerList[i].id;
          // تنظيف بيانات التحميل المؤقتة
          await TafseerUtils.removeFromActiveDownloads(tafseerId);
          await TafseerUtils.removePendingDownload(tafseerId);
        }
      }
    }
  }

  Future<void> _loadActiveDownloads() async {
    final activeDownloads = await TafseerUtils.getActiveDownloads();
    for (int i = 0; i < tafseerList.length; i++) {
      // إذا كان التفسير قد انتهى تحميله، لا تعرض شريط التقدم
      if (downloadedList[i]) {
        // تنظيف أي بيانات قديمة متعلقة بهذا التفسير
        final tafseerId = tafseerList[i].id;
        activeDownloads.remove(tafseerId);
        continue;
      }
      
      if (activeDownloads.containsKey(tafseerList[i].id)) {
        final progress = activeDownloads[tafseerList[i].id] ?? 0.0;
        if (mounted && !downloadedList[i]) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (itemKeys[i].currentState != null && !downloadedList[i]) {
              itemKeys[i].currentState?.setIsDownloading(true);
              itemKeys[i].currentState?.updateDownloadProgress(progress);
            }
          });
        }
      }
    }
  }

  Future<void> _resumePendingDownloads() async {
    final pendingDownloads = await TafseerUtils.getPendingDownloads();
    for (final entry in pendingDownloads.entries) {
      final index = tafseerList.indexWhere((t) => t.id == entry.key);
      if (index != -1 && !downloadedList[index]) {
        _startDownload(index, entry.value, tafseerList[index].name);
      }
    }
  }

  void _startDownload(int index, String url, String tafseerName) {
    final String tafseerId = tafseerList[index].id;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && itemKeys[index].currentState != null) {
        itemKeys[index].currentState?.setIsDownloading(true);
      }
    });

    TafseerUtils.downloadTafseer(
      url: url,
      onProgress: (progress) {
        if (mounted) {
          itemKeys[index].currentState?.updateDownloadProgress(progress);
          // حفظ التقدم الجاري في الـ Storage لضمان الاستمرارية
          TafseerUtils.addToActiveDownloads(tafseerId, progress);
        }
      },
      onComplete: () {
        if (mounted) {
          // تحديث downloadedList أولاً لتفعيل didUpdateWidget في الـ child
          setState(() => downloadedList[index] = true);
          // ثم استدعِ markAsDownloaded للتأكد من تحديث الـ UI
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (itemKeys[index].currentState != null) {
              itemKeys[index].currentState?.markAsDownloaded();
            }
          });
          _showSuccessMessage(tafseerName);
          // مسح البيانات المؤقتة للتنزيل من التخزين
          TafseerUtils.removePendingDownload(tafseerId);
          TafseerUtils.removeFromActiveDownloads(tafseerId);
          ref.invalidate(availableTafsserBooksProvider);
        }
      },
      onError: (errorMessage) {
        if (mounted) {
          itemKeys[index].currentState?.setIsDownloading(false);
          _showErrorMessage("تم قطع الاتصال");
          TafseerUtils.removePendingDownload(tafseerId);
          TafseerUtils.removeFromActiveDownloads(tafseerId);
        }
      },
    );
  }

  Future<void> _handleDownloadItem(int index) async {
    final bool noInternet = await NetworkInfo.hasInvalidConnection();

    if (noInternet) {
      _showErrorMessage("لا يوجد إتصال بالإنترنت");
      return;
    }

    // فحص مضاعف محلي + قاعدة البيانات
    if (downloadedList[index]) {
      _showErrorMessage("هذا التفسير مثبت بالفعل");
      return;
    }

    final String url =
        "http://10.0.2.2:8000/tafsser/tafsser_file/${tafseerList[index].id}";
    final String tafseerId = tafseerList[index].id;

    // فحص سريع من قاعدة البيانات قبل بدء التحميل
    _checkAndStartDownload(index, url, tafseerId, tafseerList[index].name);
  }

  Future<void> _checkAndStartDownload(
      int index, String url, String tafseerId, String tafseerName) async {
    // تحقق مباشرة من قاعدة البيانات
    bool isAlreadyDownloaded =
        await TafseerUtils.isTafseerDownloaded(tafseerId);

    if (isAlreadyDownloaded) {
      // تحديث الحالة المحلية إذا كانت قديمة
      if (mounted) {
        setState(() => downloadedList[index] = true);
      }
      _showErrorMessage("هذا التفسير مثبت بالفعل");
      return;
    }

    // مسح أي بيانات قديمة قبل بدء التحميل الجديد
    TafseerUtils.removeFromActiveDownloads(tafseerId);
    TafseerUtils.removePendingDownload(tafseerId);

    TafseerUtils.addPendingDownload(tafseerId, url);
    _startDownload(index, url, tafseerName);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.themeMode(ref);
    return Scaffold(
      backgroundColor: themeMode == ThemeMode.light
          ? context.color.onPrimary
          : context.color.scrim,
      appBar: const CustomAppBar(title: "تفسير", center: false, profile: false),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: tafseerList.length,
        itemBuilder: (context, index) {
          return TafsserItem(
            key: itemKeys[index],
            info: tafseerList[index],
            isDownloaded: downloadedList[index],
            onPressed: () async {
              await _handleDownloadItem(index);
            } ,
            onTap: () => showDialog(
              context: context,
              builder: (context) =>
                  TafseerDialog(tafsserInfo: tafseerList[index]),
            ),
          );
        },
      ),
    );
  }

  void _showSuccessMessage(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("تم تثبيت $name بنجاح"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String msg) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 2),

        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
