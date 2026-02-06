import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showMessage(String message, {required BuildContext context, bool isError = true}) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 3),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isError ? const Color(0xFFFFF5F5) : const Color(0xFFF0FFF4),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isError
                  ? Colors.red.withValues(alpha: .3)
                  : Colors.green.withValues(alpha: .3),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isError
                    ? Icons.info_outline_rounded
                    : Icons.check_circle_rounded,
                color: isError
                    ? const Color(0xFFD32F2F)
                    : const Color(0xFF388E3C),
                size: 22.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: isError
                        ? const Color(0xFFB71C1C)
                        : const Color(0xFF1B5E20),
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }