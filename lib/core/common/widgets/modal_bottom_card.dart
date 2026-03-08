import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';

class ModalBottomCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color forgroundColor;
  final Color? textColor;
  final void Function()? onTap;
  final IconData? trallingIcon;
  final BorderRadiusPostion? borderRadius;
  final void Function(bool)? onChanged;
  final Widget? widget;
  final Color? spalashColor;
  const ModalBottomCard({
    super.key,
    required this.icon,
    required this.text,
    required this.forgroundColor,
    this.onTap,
    this.trallingIcon,
    this.borderRadius,
    this.onChanged,
    this.widget,
    this.textColor,
    this.spalashColor,
  });

  // checkTheme
  Color checkTheme({
    required themeMode,
    required lightColor,
    required darkColor,
  }) {
    return themeMode == ThemeMode.light ? lightColor : darkColor;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius == BorderRadiusPostion.up
          ? BorderRadius.vertical(top: Radius.circular(12.r))
          : borderRadius == BorderRadiusPostion.down
          ? BorderRadius.vertical(bottom: Radius.circular(12.r))
          : BorderRadius.circular(12.r),
      splashColor: spalashColor?.withValues(alpha: .2),
      splashFactory: InkSparkle.splashFactory,
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Ink(
          height: context.heightScreen * 0.03,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(3.0.r),
                child: Icon(icon, size: 25.sp, color: forgroundColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum BorderRadiusPostion { up, down, none }
