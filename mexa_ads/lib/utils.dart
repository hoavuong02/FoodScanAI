import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';

void logger(String message) {
  if (kDebugMode) log(message);
}

String colorToHexString(Color? color, {bool leadingHashSign = true}) =>
    color == null
        ? ''
        : '${leadingHashSign ? '#' : ''}'
            '${color.alpha.toRadixString(16).padLeft(2, '0')}'
            '${color.red.toRadixString(16).padLeft(2, '0')}'
            '${color.green.toRadixString(16).padLeft(2, '0')}'
            '${color.blue.toRadixString(16).padLeft(2, '0')}';
List<String> convertColorsToHex(List<Color>? colors) {
  if (colors == null) return [];
  return colors.map((color) => colorToHexString(color)).toList();
}

enum GradientOrientation {
  leftToRight,
  topToBottom,
  rightToLeft,
  bottomToTop,
  bottomLeftToTopRight,
  bottomRightToTopLeft,
  topLeftToBottomRight,
  topRightToBottomLeft,
}

// Hàm để chuyển enum thành giá trị String
String gradientOrientationToString(GradientOrientation orientation) {
  switch (orientation) {
    case GradientOrientation.leftToRight:
      return "LEFT_RIGHT";
    case GradientOrientation.topToBottom:
      return "TOP_BOTTOM";
    case GradientOrientation.rightToLeft:
      return "RIGHT_LEFT";
    case GradientOrientation.bottomToTop:
      return "BOTTOM_TOP";
    case GradientOrientation.bottomLeftToTopRight:
      return "BL_TR";
    case GradientOrientation.bottomRightToTopLeft:
      return "BR_TL";
    case GradientOrientation.topLeftToBottomRight:
      return "TL_BR";
    case GradientOrientation.topRightToBottomLeft:
      return "TR_BL";
  }
}
