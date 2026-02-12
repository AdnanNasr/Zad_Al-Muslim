import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/extensions/sizes_ext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/l10n/app_localizations.dart';
import 'package:noor_quran/view_models/models/db/isar_db.dart';
import 'package:noor_quran/view_models/models/db/islamic/quran_models.dart';
import 'package:noor_quran/view_models/utils/app_logger.dart';

/// ✅ دالة تنظيف مدخلات البحث لتطابق النص الإملائي (Emlaey)
/// تقوم فقط بتوحيد الحروف التي قد يكتبها المستخدم بأشكال مختلفة
String cleanSearchQuery(String query) {
  String cleaned = query.trim();
  cleaned = cleaned.replaceAll(RegExp(r'[أإآٱ]'), 'ا');
  cleaned = cleaned.replaceAll('ى', 'ي');
  cleaned = cleaned.replaceAll('ة', 'ه');
  return cleaned;
}

class SearchResult {
  final String text; 
  final String surahName; 
  final int pageNumber; 
  final int ayahNumber; 
  final int surahNumber; 
  final int pageIndex; 

  SearchResult({
    required this.text,
    required this.surahName,
    required this.pageNumber,
    required this.ayahNumber,
    required this.surahNumber, 
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
    // تأكد من أن قاعدة البيانات مهيأة مسبقاً في مشروعك
    _isar = IsarDb.database!;
  }

  Future<void> _searchAyahs(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      setState(() => _results = []);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ✅ تنظيف نص البحث ليطابق النص الإملائي المخزن في قاعدة البيانات
      final cleanedQuery = cleanSearchQuery(trimmedQuery);

      // ✅ البحث مباشرة في حقل ayaTextEmlaey لضمان العثور على "قل هو" وغيرها بسهولة
      final matchedPages = await _isar.quranPages
          .filter()
          .ayahsElement((q) => q.ayaTextEmlaeyContains(cleanedQuery))
          .findAll();

      final List<SearchResult> results = [];

      for (var page in matchedPages) {
        for (var ayah in page.ayahs) {
          // ✅ مطابقة ثانوية للتأكد من جلب الآية الصحيحة فقط من داخل الصفحة
          if (ayah.ayaTextEmlaey.contains(cleanedQuery)) {
            results.add(
              SearchResult(
                text: ayah.text, // نعرض النص العثماني (بالتشكيل) في النتائج
                surahName: ayah.surahName,
                pageNumber: page.pageNumber,
                ayahNumber: ayah.ayahNumber,
                surahNumber: ayah.surahNumber,
                pageIndex: page.pageNumber - 1,
              ),
            );
          }
        }
      }

      if (mounted) {
        setState(() => _results = results);
      }
    } catch (e) {
      AppLogger.logger.e("خطأ أثناء البحث: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
            onChanged: _searchAyahs,
            style: theme.textTheme.titleMedium,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.search_placeholder,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
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

          // عرض النتائج
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            onTap: () {
              // ✅ الانتقال الفوري للفهرس الصحيح
              widget.pageController.jumpToPage(result.pageIndex);
              Navigator.of(context).pop();
            },
            title: Text(
              '${result.surahName} - آية ${result.ayahNumber}',
              textAlign: TextAlign.right,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              result.text, // النص العثماني من حقل text
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontFamily: 'Quran', // تأكد من مطابقة اسم الخط المضاف في pubspec.yaml
                height: 1.6,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.menu_book, size: 20),
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