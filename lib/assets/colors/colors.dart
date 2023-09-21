import 'package:flutter/material.dart';

class GlyconColors {
  static const whitePink = Color(0xffD8A9A9);
  static const pink = Color(0xffBA8383);
  static const purple = Color(0xff4B0D07);

  static Color withOpacity(Color color, double opacity) {
  int alpha = (opacity * 255).round();
  return color.withAlpha(alpha);
  }

}