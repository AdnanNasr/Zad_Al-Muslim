import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/features/adkar/domain/entities/adkar_entity.dart';
import 'package:noor_quran/features/adkar/presentation/providers/adkar_provider.dart';
import 'package:noor_quran/features/adkar/presentation/pages/adkar_details_page.dart';

class AdkarPage extends ConsumerStatefulWidget {
  const AdkarPage({super.key});

  @override
  ConsumerState<AdkarPage> createState() => _AdkarPageState();
}

class _AdkarPageState extends ConsumerState<AdkarPage> {
  String _searchQuery = '';
  bool _isVirtueExpanded = false;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adkarData = ref.watch(allAdkarProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'حصن المسلم',
        center: true,
        profile: false,
        icon: Icons.arrow_back,
      ),
      body: adkarData.when(
        data: (adkarList) {
          final virtueEntity = adkarList.firstWhere(
            (item) => item.category == 'فضل الذكر',
            orElse: () =>
                AdkarEntity(category: '', footnote: [], text: [], counts: []),
          );

          final filteredList = adkarList.where((item) {
            return item.category != 'فضل الذكر' &&
                item.category.contains(_searchQuery);
          }).toList();

          if (adkarList.isEmpty) {
            return const Center(child: Text('لا توجد بيانات للأذكار.'));
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: TextField(
                  controller: _textEditingController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 16.sp),
                  decoration: InputDecoration(
                    hintText: 'بحث في الأذكار...',
                    hintStyle: TextStyle(
                      fontFamily: 'Cairo',
                      color: context.color.onSurface.withValues(alpha: .5),
                    ),
                    prefixIcon: _searchQuery.isEmpty
                        ? Icon(
                            Icons.search,
                            color: context.color.primary,
                            size: 24.sp,
                          )
                        : AnimationConfiguration.synchronized(
                            duration: Duration(milliseconds: 800),
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () {
                                  _searchQuery = "";
                                  _textEditingController.text = "";
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.close,
                                  color: context.color.primary,
                                  size: 24.sp,
                                ),
                              ),
                            ),
                          ),
                    filled: true,
                    fillColor: context.color.surface,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: BorderSide(
                        color: context.color.primary.withValues(alpha: .1),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: BorderSide(
                        color: context.color.primary,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 15.h,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount:
                        filteredList.length +
                        (_searchQuery.isEmpty && virtueEntity.text.isNotEmpty
                            ? 1
                            : 0),
                    itemBuilder: (context, index) {
                      if (_searchQuery.isEmpty &&
                          virtueEntity.text.isNotEmpty &&
                          index == 0) {
                        return _buildVirtueSection(context, virtueEntity);
                      }

                      final actualIndex =
                          _searchQuery.isEmpty && virtueEntity.text.isNotEmpty
                          ? index - 1
                          : index;

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: Duration(milliseconds: 700),
                        child: SlideAnimation(
                          verticalOffset: 50,
                          child: FadeInAnimation(
                            child: _buildCategoryCard(
                              context,
                              filteredList[actualIndex],
                              actualIndex,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('حدث خطأ: ${err.toString()}')),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    AdkarEntity adkar,
    int index,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: context.color.primary.withValues(alpha: .15),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdkarDetailsPage(adkarEntity: adkar),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  // Minimalist Index
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: context.color.primary.withValues(alpha: .1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: context.color.primary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  // Title
                  Expanded(
                    child: Text(
                      adkar.category,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                        color: context.color.onSurface,
                      ),
                    ),
                  ),
                  // Trailing Icon
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14.sp,
                    color: context.color.onSurface.withValues(alpha: .3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVirtueSection(BuildContext context, AdkarEntity virtue) {
    final displayedText = _isVirtueExpanded
        ? virtue.text
        : virtue.text.take(3).toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.color.primary.withValues(alpha: .03),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.color.primary.withValues(alpha: .05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.star_rounded,
                color: context.color.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'فضائل الذكر',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: context.color.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayedText.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              return SelectableText(
                displayedText[index],
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14.sp,
                  height: 1.6,
                  color: context.color.onSurface.withValues(alpha: .8),
                ),
              );
            },
          ),
          if (virtue.text.length > 3)
            TextButton(
              onPressed: () {
                setState(() {
                  _isVirtueExpanded = !_isVirtueExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isVirtueExpanded ? 'عرض أقل' : 'عرض المزيد من الفضائل',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: context.color.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    _isVirtueExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: context.color.primary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
