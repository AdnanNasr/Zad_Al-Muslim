import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/features/quran/presentation/pages/quran_pages.dart';
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
                        if (words.isEmpty) {
                          setState(() => _searchResults = []);
                          return;
                        }

                        final normalizedWords = qcf.removeDiacritics(
                          words.trim(),
                        );
                        final searchResponse = qcf.searchWords(normalizedWords);
                        setState(() {
                          final results = List<Map>.from(
                            searchResponse["result"] ?? [],
                          );
                          _searchResults = results.map((e) {
                            final surahNumber = e["suraNumber"] as int;
                            final verseNumber = e["verseNumber"] as int;
                            return {
                              'surahNumber': surahNumber,
                              'ayahNumber': verseNumber,
                              'surah': qcf.getSurahNameArabic(surahNumber),
                              'ayah': verseNumber.toString(),
                              'text': qcf.getVerse(
                                surahNumber,
                                verseNumber,
                                verseEndSymbol: true,
                              ),
                            };
                          }).toList();
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

                  // Mockup Results
                  // TODO
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
            color: context.color.primary.withValues(alpha: .05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
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
              // !change font TODO
              item['text'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: '', // Assuming this exists or falls back
                fontSize: 18.sp,
                height: 1.8,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
