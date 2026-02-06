import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/extensions/sizes_ext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/l10n/app_localizations.dart';
// افتراض استيراد النماذج وقاعدة البيانات
// تم التأكد من أن هذه المسارات هي المطلوبة بناءً على سياق المشروع
import 'package:noor_quran/view_models/models/db/isar_db.dart';
import 'package:noor_quran/view_models/models/db/islamic/quran_models.dart';
import 'package:noor_quran/view_models/utils/app_logger.dart';

// --- دالة المساعدة لإزالة التشكيل وتوحيد الأحرف ---
// تم إضافتها هنا لضمان وجودها أثناء عملية البحث
String normalizeArabicText(String text) {
  // 1. ✅ إزالة التشكيل (الحركات)، بما في ذلك الألف الخنجرية والمدود والرموز الخاصة
  // U+064B - U+065F: الحركات الأساسية والشدة والسكون
  // U+0670: الألف الخنجرية (Small Alif)
  // U+0621 - U+063A: قد تحتوي على حروف تشكيل إضافية
  // U+08F0 - U+08F2: رموز الرسم العثماني لهزة الوصل وغيرها
  // U+0640: حرف المد
  String normalized = text.replaceAll(
    RegExp(r'[\u064B-\u065F\u0670\u0640\u08F0-\u08F2]'),
    '',
  );

  // 2. توحيد الألف (أ, إ, آ) -> ا
  normalized = normalized.replaceAll(RegExp(r'[أإآ]'), 'ا');

  // 3. توحيد الياء (ي, ى) -> ي (لضمان مطابقة الياءات غير المنقوطة)
  normalized = normalized.replaceAll('ى', 'ي');

  // 4. توحيد التاء المربوطة -> هاء
  normalized = normalized.replaceAll('ة', 'ه');

  // 5. إزالة أي رمز قد لا يزال يسبب مشكلة (مثل رمز همزة الوصل: ٱ)
  normalized = normalized.replaceAll('ٱ', '');

  return normalized;
}
// -----------------------------------------

// نموذج بسيط لتمثيل نتيجة البحث
class SearchResult {
  final String text; // نص الآية
  final String surahName; // اسم السورة
  final int pageNumber; // رقم الصفحة
  final int ayahNumber; // رقم الآية
  final int surahNumber; // ✅ رقم السورة (مضاف لتظليل الآية)
  final int pageIndex; // الفهرس (index) الذي سيمرر لدالة goToPage

  SearchResult({
    required this.text,
    required this.surahName,
    required this.pageNumber,
    required this.ayahNumber,
    required this.surahNumber, // ✅ مطلوب
    required this.pageIndex,
  });
}

class SearchPage extends StatefulWidget {
  final PageController pageController;
  final List<QuranPage> pages;

  const SearchPage({
    super.key,
    required this.pageController,
    required this.pages,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _results = [];
  bool _isLoading = false;

  late Isar _isar;

  @override
  void initState() {
    super.initState();
    // استخدام دالة التهيئة التي قدمها المستخدم، وهي آمنة للاستدعاء المتكرر
    _initIsar();
  }

  // تهيئة Isar للتأكد من جاهزيته قبل البحث
  Future<void> _initIsar() async {
    // نستخدم IsarDb.initDatabase وهي تقوم بإرجاع النسخة المفتوحة أو فتحها إن لزم الأمر
    _isar = await IsarDb.initDatabase();
    setState(() {});
  }

  // دالة البحث الرئيسية باستخدام Isar (مُعدَّلة لاستخدام textNormalized)
  Future<void> _searchAyahs(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }

    // تأكد من أن قاعدة البيانات متاحة قبل البحث
    if (!mounted || !_isar.isOpen) return;

    setState(() {
      _isLoading = true;
      _results = [];
    });

    try {
      // 1. ✅ تطبيع مدخلات المستخدم (إزالة التشكيل والتوحيد)
      final normalizedQuery = normalizeArabicText(trimmedQuery);

      // 2. ✅ البحث باستخدام الحقل المُطابِق (textNormalized)
      final List<QuranPage> matchedPages = await _isar.quranPages
          .filter()
          // ayahsElement يطبق الفلتر على كل عنصر في القائمة المضمنة
          // نستخدم textNormalizedContains بدلاً من textContains
          // لا نحتاج لـ caseSensitive: false لأننا قمنا بالتطبيع بالفعل
          .ayahsElement((q) => q.textNormalizedContains(normalizedQuery))
          .findAll();

      final List<SearchResult> results = [];

      // 3. تحليل الصفحات المطابقة واستخراج الآيات الفعلية المطابقة
      for (var page in matchedPages) {
        // حساب فهرس الصفحة (index) ليتم تمريره إلى goToPage، نفترض أن صفحتك الأولى هي 1 (فهرس 0)
        final pageIndex = page.pageNumber;

        for (var ayah in page.ayahs) {
          // 4. ✅ نستخدم الحقل المُطابِق (textNormalized) للمطابقة الدقيقة في الذاكرة
          if (ayah.textNormalized.contains(normalizedQuery)) {
            results.add(
              SearchResult(
                // نعرض النص الأصلي (بالتشكيل)
                text: ayah.text,
                surahName: ayah.surahName,
                pageNumber: page.pageNumber,
                ayahNumber: ayah.ayahNumber,
                surahNumber: ayah.surahNumber, // ✅ إضافة رقم السورة
                pageIndex: pageIndex,
              ),
            );
          }
        }
      }

      if (mounted) {
        setState(() {
          _results = results;
        });
      }
    } catch (e) {
      AppLogger.logger.e("Error while searching: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: ScreenUtil().screenHeight * 0.8,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // شريط البحث
          TextField(
            controller: _searchController,
            onChanged: (value) => _searchAyahs(value),
            style: theme.textTheme.titleMedium,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.search_placeholder,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _searchAyahs('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: theme.cardColor,
            ),
          ),

          const SizedBox(height: 16),

          // نتائج البحث
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildResultsList(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(ThemeData theme) {
    if (_results.isEmpty && _searchController.text.isNotEmpty) {
      return Center(
        child: Text(
          'لا توجد نتائج مطابقة لـ "${_searchController.text}"',
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_results.isEmpty && _searchController.text.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.start_searching,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.grey.shade500,
            fontSize: context.witdthScreen * 0.035,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final result = _results[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () {
              final pageNumber = result.pageNumber;
              final targetIndex = widget.pages.indexWhere(
                (p) => p.pageNumber == pageNumber,
              );
              if (targetIndex != -1) {
                widget.pageController.animateToPage(
                  targetIndex,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                );
              }
              Navigator.of(context).pop();
            },
            title: Text(
              '${result.surahName} - آية ${result.ayahNumber}',
              textAlign: TextAlign.right,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.primaryColor,
              ),
            ),
            subtitle: Text(
              result.text,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: theme.textTheme.bodyLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.menu_book),
                Text(
                  'ص ${result.pageNumber}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
