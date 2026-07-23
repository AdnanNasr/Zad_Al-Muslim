import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InternetErrorMessage {
  static void showMessage({required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 900),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        content: Row(
          children: [
            Icon(
              Icons.wifi_off_rounded,
              color: Theme.of(context).colorScheme.onErrorContainer,
              size: 18,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'يرجى التحقق من إتصالك بالإنترنت.',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
