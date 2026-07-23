import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/adkar/domain/entities/adkar_entity.dart';
import 'package:zad_al_muslim/features/adkar/presentation/providers/adkar_provider.dart';
import 'package:zad_al_muslim/features/adkar/presentation/pages/adkar_details_page.dart';

class AdkarPage extends ConsumerStatefulWidget {
  const AdkarPage({super.key});

  @override
  ConsumerState<AdkarPage> createState() => _AdkarPageState();
}

class _AdkarPageState extends ConsumerState<AdkarPage> {
  String _searchQuery = '';
  bool _isVirtueExpanded = false;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adkarData = ref.watch(allAdkarProvider);

    return Scaffold(
      backgroundColor: context.color.surfaceContainerLowest,
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

          return SafeArea(
            child: Column(
              children: [
                const _AdkarHeader(),
                Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 10.h),
                  child: TextField(
                    controller: _textEditingController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 13.sp),
                    decoration: InputDecoration(
                      hintText: 'بحث في الأذكار...',
                      hintStyle: TextStyle(
                        fontFamily: 'Cairo',
                        color: context.color.onSurfaceVariant,
                      ),
                      prefixIcon: _searchQuery.isEmpty
                          ? Icon(
                              Icons.search,
                              color: context.color.tertiary,
                              size: 24.sp,
                            )
                          : AnimationConfiguration.synchronized(
                              duration: const Duration(milliseconds: 800),
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: () {
                                    _searchQuery = "";
                                    _textEditingController.text = "";
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: context.color.tertiary,
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
                          color: context.color.outlineVariant,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide: BorderSide(
                          color: context.color.tertiary,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 13.h,
                      ),
                    ),
                  ),
                ),
                if (filteredList.isEmpty)
                  Expanded(child: _EmptySearch(query: _searchQuery))
                else
                  Expanded(
                    child: AnimationLimiter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          trackVisibility: true,
                          interactive: true,
                          thickness: 5,
                          radius: const Radius.circular(24),
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount:
                                filteredList.length +
                                (_searchQuery.isEmpty &&
                                        virtueEntity.text.isNotEmpty
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (_searchQuery.isEmpty &&
                                  virtueEntity.text.isNotEmpty &&
                                  index == 0) {
                                return _buildVirtueSection(
                                  context,
                                  virtueEntity,
                                );
                              }

                              final actualIndex =
                                  _searchQuery.isEmpty &&
                                      virtueEntity.text.isNotEmpty
                                  ? index - 1
                                  : index;

                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 700),
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
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const _AdkarLoading(),
        error: (err, stack) =>
            _AdkarError(onRetry: () => ref.invalidate(allAdkarProvider)),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    AdkarEntity adkar,
    int index,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      child: Material(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdkarDetailsPage(adkarEntity: adkar),
              ),
            );
          },
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: scheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    _categoryIcon(adkar.category),
                    color: scheme.onTertiaryContainer,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        adkar.category,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Cairo',
                          color: scheme.onSurface,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${adkar.text.length} ذكر',
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontFamily: 'Cairo',
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15.sp,
                  color: scheme.onSurfaceVariant,
                ),
              ],
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
        color: context.color.tertiaryContainer.withValues(alpha: .35),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: context.color.tertiary.withValues(alpha: .28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.star_rounded,
                color: context.color.tertiary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'فضائل الذكر',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: context.color.onTertiaryContainer,
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
              return Text(
                displayedText[index],
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14.sp,
                  height: 1.6,
                  color: context.color.onSurfaceVariant,
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
                      color: context.color.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    _isVirtueExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: context.color.tertiary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
    if (category.contains('الصباح') || category.contains('الاستيقاظ')) {
      return Icons.wb_sunny_rounded;
    }
    if (category.contains('المساء') || category.contains('النوم')) {
      return Icons.nightlight_round;
    }
    if (category.contains('الصلاة') || category.contains('المسجد')) {
      return Icons.mosque_rounded;
    }
    if (category.contains('قرآن')) return Icons.menu_book_rounded;
    if (category.contains('استغفار') || category.contains('توبة')) {
      return Icons.auto_awesome_rounded;
    }
    return Icons.volunteer_activism_rounded;
  }
}

class _AdkarHeader extends StatelessWidget {
  const _AdkarHeader();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 8.h),
      child: Row(
        children: [
          IconButton.filledTonal(
            tooltip: 'العودة',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          SizedBox(width: 10.w),
          Container(
            width: 46.r,
            height: 46.r,
            decoration: BoxDecoration(
              color: scheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(
              Icons.volunteer_activism_rounded,
              color: scheme.onTertiaryContainer,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الأذكار والأدعية',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  'حصنك اليومي من الذكر والدعاء',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10.5.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48.sp,
              color: scheme.onSurfaceVariant,
            ),
            SizedBox(height: 12.h),
            Text(
              'لا توجد نتائج لـ «$query»',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdkarLoading extends StatelessWidget {
  const _AdkarLoading();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          _AdkarHeader(),
          Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}

class _AdkarError extends StatelessWidget {
  const _AdkarError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Column(
        children: [
          const _AdkarHeader(),
          Expanded(
            child: Center(
              child: Container(
                margin: EdgeInsets.all(24.r),
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 40.sp,
                      color: scheme.error,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'تعذر تحميل الأذكار',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    FilledButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
