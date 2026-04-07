import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/features/adkar/presentation/providers/adkar_provider.dart';
import 'package:noor_quran/features/adkar/presentation/pages/adkar_details_page.dart';

class AdkarPage extends ConsumerStatefulWidget {
  const AdkarPage({super.key});

  @override
  ConsumerState<AdkarPage> createState() => _AdkarPageState();
}

class _AdkarPageState extends ConsumerState<AdkarPage> {
  String _searchQuery = '';

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
          final filteredList = adkarList.where((item) {
            return item.category.contains(_searchQuery);
          }).toList();

          if (adkarList.isEmpty) {
            return const Center(child: Text('لا توجد بيانات للأذكار.'));
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'بحث في الأذكار...',
                    prefixIcon: Icon(Icons.search, color: context.color.primary),
                    filled: true,
                    fillColor: context.color.primary.withValues(alpha: .05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final category = filteredList[index];
                    return _buildCategoryCard(context, category);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('حدث خطأ: ${err.toString()}')),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, dynamic category) {
    IconData iconData = _getIconForCategory(category.category);
    
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdkarDetailsPage(adkarEntity: category),
          ),
        );
      },
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: context.color.primary.withValues(alpha: .1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: context.color.primary.withValues(alpha: .08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: context.color.primary,
                size: 28.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              category.category,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: context.color.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    if (category.contains('صباح') || category.contains('مساء')) return Icons.wb_sunny_outlined;
    if (category.contains('نوم')) return Icons.bedtime_outlined;
    if (category.contains('صلاة') || category.contains('وضوء')) return Icons.mosque_outlined;
    if (category.contains('طعام')) return Icons.restaurant_menu;
    if (category.contains('سفر')) return Icons.flight_takeoff;
    if (category.contains('هم') || category.contains('كرب')) return Icons.sentiment_very_dissatisfied;
    if (category.contains('مريض')) return Icons.medical_services_outlined;
    if (category.contains('لبس')) return Icons.checkroom;
    if (category.contains('خروج') || category.contains('دخول')) return Icons.door_front_door_outlined;
    return Icons.auto_stories_outlined; // Default
  }
}
