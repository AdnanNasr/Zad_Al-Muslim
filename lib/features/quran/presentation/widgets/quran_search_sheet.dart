import 'dart:async';
import 'package:zad_al_muslim/features/quran/domain/services/quran_search_indexer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  Timer? _debounce;

  // Recent Searches
  static final List<Map<String, dynamic>> _recentSearches = [];

  List<Map> _searchResults = [];

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String words) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(words);
    });
  }

  void _performSearch(String words) {
    final query = words.trim();
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    if (!QuranSearchIndexer.isReady) {
      return;
    }

    final searchStr = robustNormalizeQuranText(query);
    // جعل البحث مرناً (Fuzzy) بوضع احتمالية وجود ألف أو واو أو ياء خنجرية
    // بين أي حرفين، مما يحل مشكلة الإملاء القياسي ضد الرسم العثماني.
    final regexPattern = searchStr.split('').join('(?:[اوى]*)');
    final searchRegex = RegExp(regexPattern);

    setState(() {
      _searchResults = QuranSearchIndexer.cache
          .where((ayah) {
            return searchRegex.hasMatch(ayah['normalized'] as String);
          })
          .take(50)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: context.color.surfaceContainerLowest,
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
              color: context.color.outlineVariant,
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
                      color: context.color.surface,
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(color: context.color.outlineVariant),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(fontFamily: 'Naskh', fontSize: 16.sp),
                      decoration: InputDecoration(
                        hintText: 'ابحث عن سورة أو آية...',
                        fillColor: Colors.transparent,
                        hintStyle: TextStyle(
                          fontFamily: 'Cairo',
                          color: context.color.onSurfaceVariant,
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
                      onChanged: _onSearchChanged,
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: CustomScrollView(
                slivers: [
                  if (_searchController.text.trim().isEmpty &&
                      _recentSearches.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _SearchEmptyState(
                        icon: Icons.travel_explore_rounded,
                        title: 'ابحث في آيات القرآن',
                        subtitle:
                            'اكتب كلمة أو جزءاً من آية للوصول إليها بسرعة.',
                      ),
                    ),
                  if (_searchController.text.trim().isNotEmpty &&
                      _searchResults.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _SearchEmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'لا توجد نتائج',
                        subtitle: 'تحقق من الكتابة أو جرّب عبارة أقصر.',
                      ),
                    ),
                  if (_recentSearches.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'عمليات البحث الأخيرة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: context.color.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: _recentSearches.map((search) {
                              return ActionChip(
                                label: Text(
                                  'سورة ${search['surah']} - آية ${search['ayah']}',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: context.color.primary,
                                  ),
                                ),
                                backgroundColor:
                                    context.color.surfaceContainerLow,
                                side: BorderSide(
                                  color: context.color.outlineVariant,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                onPressed: () {
                                  final surahNum = search['surahNumber'] as int;
                                  final verseNum = search['ayahNumber'] as int;
                                  _replaceWithAyah(surahNum, verseNum);
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  if (_searchResults.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'نتائج مقترحة',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: context.color.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'نتائج البحث (${_searchResults.length})',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: context.color.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 12.h),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return _buildResultItem(context, _searchResults[index]);
                      }, childCount: _searchResults.length),
                    ),
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

        _replaceWithAyah(surahNumber, verseNumber);
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.dg),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.color.outlineVariant),
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
                    color: context.color.onSurfaceVariant,
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

  Future<void> _replaceWithAyah(int surahNumber, int verseNumber) async {
    final navigator = Navigator.of(context);
    await navigator.maybePop();
    if (!navigator.mounted) return;

    await navigator.pushReplacement(
      MaterialPageRoute(
        builder: (_) => QuranPages(
          pageNumber: qcf.getPageNumber(surahNumber, verseNumber),
          highlightSurah: surahNumber,
          highlightVerse: verseNumber,
        ),
      ),
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: scheme.tertiaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40.sp, color: scheme.onTertiaryContainer),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12.sp,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
