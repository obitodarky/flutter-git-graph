import 'package:flutter/material.dart';

class ColorUtil {

  static Color getColor(double value, Color minColor, Color maxColor) {
    // Ensure value stays within the 0.0 to 1.0 range
    value = value.clamp(0.0, 1.0);

    // Interpolate red, green, and blue values between minColor and maxColor
    int red = (minColor.red + (maxColor.red - minColor.red) * value).toInt();
    int green = (minColor.green + (maxColor.green - minColor.green) * value).toInt();
    int blue = (minColor.blue + (maxColor.blue - minColor.blue) * value).toInt();

    // Return the resulting interpolated color
    return Color.fromARGB(255, red, green, blue);
  }
}