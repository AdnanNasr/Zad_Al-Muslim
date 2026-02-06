import 'package:flutter/material.dart';

extension ColorExt on BuildContext{
  // get color schema
  ColorScheme get color => Theme.of(this).colorScheme;
}