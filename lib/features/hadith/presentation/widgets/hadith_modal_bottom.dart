import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/features/hadith/domain/entities/hadith_entity.dart';

class HadithModalBottom extends ConsumerWidget {
  final HadithEntity hadith;
  const HadithModalBottom({super.key, required this.hadith});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // ليأخذ الارتفاع المطلوب فقط
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مقبض السحب العلوي
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // العنوان والمصدر
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "المصدر: ${hadith.book}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Cairo",
                  ),
                ),
                _buildGradeChip(hadith.grade.name),
              ],
            ),

            SizedBox(height: 15.h),

            // نص الحديث داخل بطاقة بظل خفيف
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.r),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: SelectableText(
                hadith.hadith,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  height: 2.2.h,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Naskh", // يفضل للأحاديث
                ),
              ),
            ),

            SizedBox(height: 20.h),
            const Divider(),
            SizedBox(height: 10.h),

            // التفاصيل السفلية بتنسيق أيقونات
            _buildDetailRow(
              Icons.person_outline,
              "الراوي",
              hadith.hadithNarrator,
              context,
            ),
            _buildDetailRow(
              Icons.topic_outlined,
              "الموضوع",
              hadith.topic,
              context,
            ),

            SizedBox(height: 30.h), // مساحة أمان سفلية
          ],
        ),
      ),
    );
  }

  // ودجت لدرجة الحديث ملونة
  Widget _buildGradeChip(String grade) {
    Color color;
    String label;
    switch (grade) {
      case "sahih":
        color = Colors.green;
        label = "صحيح";
        break;
      case "hasan":
        color = Colors.orange;
        label = "حسن";
        break;
      case "daif":
        color = Colors.red;
        label = "ضعيف";
        break;
      default:
        color = Colors.grey;
        label = "غير معروف";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: .5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ويدجت صف التفاصيل المحسن
  Widget _buildDetailRow(
    IconData icon,
    String title,
    String value,
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.r, color: Colors.grey.shade600),
          SizedBox(width: 8.w),
          Text(
            "$title: ",
            style: TextStyle(
              fontSize: 16.sp,
              // fontWeight: FontWeight.bold,
              fontFamily: "Cairo",
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                color: Theme.of(context).colorScheme.primary,
                // fontWeight: FontWeight.bold,
                fontFamily: "Cairo",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
