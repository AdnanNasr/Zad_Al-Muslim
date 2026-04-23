import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "مركز الإشعارات",
        center: false,
        profile: false,
      ),
      body: Center(
        child: Text(
          "لا يوجد إشعارات في الوقت الحالي",
          style: TextStyle(
            fontSize: 20.sp,
            color: context.color.outline.withValues(alpha: .9),
          ),
        ),
      ),
    );
  }
}
