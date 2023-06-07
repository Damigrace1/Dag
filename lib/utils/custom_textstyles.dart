import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextStyle extends TextStyle {
  CustomTextStyle({
    double? spacing,
    double? height,
    double? fontSize,
    FontStyle fontStyle = FontStyle.normal,
    FontWeight fontWeight = FontWeight.w400,
    Color? color = Colors.white,
    TextOverflow? overflow,
    bool underline = false,
  }) : super(
    color: color,
    overflow: overflow,
    fontSize: fontSize ?? 16.w,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    fontFamily: 'Poppins',
    height: height,
    letterSpacing: spacing,
    decoration: underline ? TextDecoration.underline : null,
  );
}