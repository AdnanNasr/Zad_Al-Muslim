import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ScreenType on BuildContext {
  bool get isMobile =>
      ScreenUtil().screenWidth > 360 && ScreenUtil().screenWidth < 600;
  bool get isTablet => ScreenUtil().screenWidth >= 600;
  bool get isSmallMobile => ScreenUtil().screenWidth <= 360;

  // يمكنك حتى إرجاع قيم مختلفة بناءً على الحجم
  double responsiveValue(double small, double medium, double large) {
    if (isSmallMobile) return small;
    if (isMobile) return medium;
    return large;
  }
}
