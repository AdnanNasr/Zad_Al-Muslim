import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/common/widgets/page_header.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';

class NotificationsPage extends StatelessWidget {
  // TODO: complete and intgrate notifications page
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(
              tooltip: 'العودة',
              icon: Icons.notifications_outlined,
              title: 'الإشعارات',
              subTitle: 'تابع آخر التنبيهات',
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off_outlined, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    "لا يوجد إشعارات في الوقت الحالي",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: context.color.outline.withValues(alpha: .9),
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
