import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';

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

  // Dummy Data
  final List<Map<String, String>> _recentSearches = [
    {'title': 'سورة البقرة'},
    {'title': 'آية الكرسي'},
    {'title': 'يس'},
  ];

  final List<Map<String, dynamic>> _dummyResults = [
    {
      'surah': 'البقرة',
      'ayah': '1',
      'text':
          'الم (1) ذَلِكَ الْكِتَابُ لاَ رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ',
      'surahNumber': 2,
    },
    {
      'surah': 'الفاتحة',
      'ayah': '1',
      'text': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
      'surahNumber': 1,
    },
    {
      'surah': 'الكهف',
      'ayah': '10',
      'text':
          'إِذْ أَوَى الْفِتْيَةُ إِلَى الْكَهْفِ فَقَالُوا رَبَّنَا آتِنَا مِن لَّدُنكَ رَحْمَةً',
      'surahNumber': 18,
    },
    {
      'surah': 'الكهف',
      'ayah': '10',
      'text':
          'إِذْ أَوَى الْفِتْيَةُ إِلَى الْكَهْفِ فَقَالُوا رَبَّنَا آتِنَا مِن لَّدُنكَ رَحْمَةً',
      'surahNumber': 18,
    },
    {
      'surah': 'الكهف',
      'ayah': '10',
      'text':
          'إِذْ أَوَى الْفِتْيَةُ إِلَى الْكَهْفِ فَقَالُوا رَبَّنَا آتِنَا مِن لَّدُنكَ رَحْمَةً',
      'surahNumber': 18,
    },
    {
      'surah': 'الكهف',
      'ayah': '10',
      'text':
          'إِذْ أَوَى الْفِتْيَةُ إِلَى الْكَهْفِ فَقَالُوا رَبَّنَا آتِنَا مِن لَّدُنكَ رَحْمَةً',
      'surahNumber': 18,
    },
  ];

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
                    child: Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: 'ابحث عن سورة أو آية...',
                          fillColor: context.color.primary.withValues(
                            alpha: .05,
                          ),
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
                      ),
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
                          child: Chip(
                            label: Text(
                              search['title']!,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12.sp,
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
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 24.h),

                  // Results Title
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
                  ...List.generate(_dummyResults.length, (index) {
                    final item = _dummyResults[index];
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.dg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.color.primary.withValues(alpha: .05)),
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
            item['text'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'quran_font', // Assuming this exists or falls back
              fontSize: 18.sp,
              height: 1.8,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
