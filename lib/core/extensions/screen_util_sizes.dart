import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ScreenType on BuildContext {
  bool get small =>
      ScreenUtil().screenWidth > 360 && ScreenUtil().screenWidth < 600;
  bool get medium => ScreenUtil().screenWidth >= 600;
  bool get large => ScreenUtil().screenWidth <= 360;
}
