import 'package:zad_al_muslim/core/common/constants/surah_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/quran_pages.dart';
import 'package:qcf_quran/qcf_quran.dart' as qcf;

class QuranSearchSheet extends StatefulWidget {
  const QuranSearchSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuranSearchSheet(),
    );
  }

  @override
  State<QuranSearchSheet> createState() => _QuranSearchSheetState();
}

class _QuranSearchSheetState extends State<QuranSearchSheet> {
  final TextEditingController _searchController = TextEditingController();

  // Recent Searches
  static final List<Map<String, dynamic>> _recentSearches = [];

  List<Map> _searchResults = [];

  static List<Map<String, dynamic>> _quranNormalizedCacheV2 = [];

  @override
  void initState() {
    super.initState();
    _indexQuranForSearch();
  }

  void _indexQuranForSearch() {
    if (_quranNormalizedCacheV2.isNotEmpty) return;

    final List<Map<String, dynamic>> tempIndex = [];
    for (int surah = 1; surah <= 114; surah++) {
      int vCount = qcf.getVerseCount(surah);
      for (int verse = 1; verse <= vCount; verse++) {
        String rawVerse = qcf.getVerse(surah, verse, verseEndSymbol: false);
        String normal = _robustNormalize(rawVerse);
        tempIndex.add({
          'surahNumber': surah,
          'ayahNumber': verse,
          'surah': SurahNames.getFormattedName(surah),
          'ayah': verse.toString(),
          'text': rawVerse,
          'normalized': normal,
        });
      }
    }
    _quranNormalizedCacheV2 = tempIndex;
  }

  String _robustNormalize(String input) {
    // 1. تحويل العلامات القرآنية الصغيرة إلى حروف مقابلة لتُحفظ في الفهرس
    String s = input.replaceAll('\u0670', 'ا'); // الألف الخنجرية
    s = s.replaceAll('\u06E5', 'و'); // الواو الصغيرة
    s = s.replaceAll('\u06E6', 'ى'); // الياء الصغيرة

    // 2. إزالة جميع التشكيلات وعلامات الوقف القرآنية والتطويل
    String clean = s.replaceAll(
      RegExp(r'[\u064B-\u065F\u06D6-\u06ED\u0640]'),
      '',
    );

    // 3. توحيد الحروف للبحث المرن
    return clean
        .replaceAll(RegExp(r'[أإآاٱ]'), 'ا') // توحيد الألف وهمزة الوصل
        .replaceAll('ة', 'ه') // توحيد التاء المربوطة
        .replaceAll(
          RegExp(r'[يىئ]'),
          'ى',
        ) // توحيد الياء والألف المقصورة والنبرة
        .replaceAll('ؤ', 'و')
        .replaceAll(RegExp(r'\s+'), ' ') // إزالة المسافات المزدوجة
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),

          // Search Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 0, right: 15.w),
                    decoration: BoxDecoration(
                      color: context.color.primary.withValues(alpha: .05),
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(15.r),
                        left: Radius.circular(8.r),
                      ),
                      border: Border.all(
                        color: context.color.primary.withValues(alpha: .1),
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(fontFamily: 'Naskh', fontSize: 16.sp),
                      decoration: InputDecoration(
                        hintText: 'ابحث عن سورة أو آية...',
                        fillColor: context.color.primary.withValues(alpha: .05),
                        hintStyle: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.grey[400],
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                        maintainHintSize: true,
                        icon: Icon(
                          Icons.search_rounded,
                          color: context.color.primary,
                          size: 22.sp,
                        ),
                      ),
                      onChanged: (words) {
                        final query = words.trim();
                        if (query.isEmpty) {
                          setState(() => _searchResults = []);
                          return;
                        }

                        final searchStr = _robustNormalize(query);
                        // جعل البحث مرناً (Fuzzy) بوضع احتمالية وجود ألف أو واو أو ياء خنجرية
                        // بين أي حرفين، مما يحل مشكلة الإملاء القياسي ضد الرسم العثماني.
                        final regexPattern = searchStr
                            .split('')
                            .join('(?:[اوى]*)');
                        final searchRegex = RegExp(regexPattern);

                        setState(() {
                          _searchResults = _quranNormalizedCacheV2
                              .where((ayah) {
                                return searchRegex.hasMatch(
                                  ayah['normalized'] as String,
                                );
                              })
                              .take(50)
                              .toList();
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: context.color.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Content
          Expanded(
            child: AnimationLimiter(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  if (_recentSearches.isNotEmpty) ...[
                    // Recent Searches Title
                    Text(
                      'عمليات البحث الأخيرة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Recent Search Chips
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: _recentSearches.map((search) {
                        return AnimationConfiguration.staggeredList(
                          position: 0,
                          duration: const Duration(milliseconds: 375),
                          child: FadeInAnimation(
                            child: ActionChip(
                              label: Text(
                                'سورة ${search['surah']} - آية ${search['ayah']}',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: context.color.primary,
                                ),
                              ),
                              backgroundColor: context.color.primary.withValues(
                                alpha: .05,
                              ),
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              onPressed: () {
                                final surahNum = search['surahNumber'] as int;
                                final verseNum = search['ayahNumber'] as int;
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuranPages(
                                      pageNumber: qcf.getPageNumber(
                                        surahNum,
                                        verseNum,
                                      ),
                                      highlightSurah: surahNum,
                                      highlightVerse: verseNum,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24.h),
                  ],

                  // Results Title
                  if (_searchResults.isNotEmpty)
                    Text(
                      'نتائج مقترحة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  SizedBox(height: 12.h),

                  if (_searchResults.isNotEmpty) ...[
                    Text(
                      'نتائج البحث (${_searchResults.length})',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ...List.generate(_searchResults.length, (index) {
                      final item = _searchResults[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 30,
                          child: FadeInAnimation(
                            child: _buildResultItem(context, item),
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(BuildContext context, Map item) {
    return InkWell(
      onTap: () {
        final surahNumber = item['surahNumber'] as int;
        final verseNumber = item['ayahNumber'] as int;

        setState(() {
          _recentSearches.removeWhere(
            (e) =>
                e['surahNumber'] == surahNumber &&
                e['ayahNumber'] == verseNumber,
          );
          _recentSearches.insert(0, {
            'surah': item['surah'],
            'ayah': item['ayah'],
            'surahNumber': surahNumber,
            'ayahNumber': verseNumber,
          });
          if (_recentSearches.length > 5) {
            _recentSearches.removeLast();
          }
        });

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuranPages(
              pageNumber: qcf.getPageNumber(surahNumber, verseNumber),
              highlightSurah: surahNumber,
              highlightVerse: verseNumber,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.dg),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: context.color.primary.withValues(alpha: .3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 16.sp,
                      color: context.color.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'سورة ${item['surah']}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: context.color.primary,
                      ),
                    ),
                  ],
                ),
                Text(
                  'آية ${item['ayah']}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              item['text'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Quran',
                fontSize: 19.sp,
                height: 1.8,
                color: context.color.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
