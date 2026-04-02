import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizesExt on BuildContext {
  //-----------------ScreenUtil------------------------
  // get full screen size via ScreenUtil
  Size get screen => Size(ScreenUtil().screenWidth, ScreenUtil().screenHeight);
  // get full height size
  double get heightScreen => ScreenUtil().screenHeight;
  // get full width size
  double get widthScreen => ScreenUtil().screenWidth;
  double get witdthScreen => ScreenUtil().screenWidth; // Keep for compatibility

  //-----------------MediaQuery------------------------
  Size get mediaQuery => MediaQuery.of(this).size;
  double get mediaQueryWidth => mediaQuery.width;
  double get mediaQueryHeight => mediaQuery.height;
}
