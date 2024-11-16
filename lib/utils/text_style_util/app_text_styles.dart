import 'package:flutter/material.dart';
import 'package:flutter_git_graph/utils/color/color_util.dart';

class AppTextStyles {
  static TextStyle headingTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: ColorUtil.textColorPrimary,
  );

  static TextStyle subtitleTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ColorUtil.textColorSecondary,
  );

  static TextStyle transactionTextStyle = const TextStyle(
    fontSize: 12,
    color: ColorUtil.textColorPrimary,
  );
}