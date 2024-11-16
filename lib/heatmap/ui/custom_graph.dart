import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_git_graph/heatmap/ui/heatmap_options.dart';

class HeatmapPainter extends CustomPainter {
  final List<double?> data; // The actual data
  final HeatmapOptions options;

  HeatmapPainter({
    required this.data,
    required this.options,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final double cellSizeWithPadding = options.cellSize + options.cellPadding;
    //TODO: need to make sure empty list/null case is being handled
    final minValue = data.cast<num>().reduce(min);
    final maxValue = data.cast<num>().reduce(max);


    // Paint cells column by column (column-major order)
    for (int col = 0; col < options.maxColumns; col++) {
      for (int row = 0; row < options.maxRows; row++) {
        final double? cellData = _getCellData(row, col);


        // Only draw cells that have data (not null)
        if (cellData != null) {
          paint.color = _getCellColor(
            cellData: cellData,
            minValue: minValue,
            maxValue: maxValue,
            gradientColors: options.gradientColors,
          );
          final Rect rect = _getCellRect(row, col, cellSizeWithPadding);

          if (rect.left < size.width &&
              rect.right > 0 &&
              rect.top < size.height &&
              rect.bottom > 0) {
            final RRect rRect =
                RRect.fromRectAndRadius(rect, options.cellRadius);
            canvas.drawRRect(rRect, paint);
          }
        }
      }
    }
  }

  /// Get the data for a specific cell using column-major order
  double? _getCellData(int row, int col) {
    final int index = col * options.maxRows + row;
    if (index < 0 || index >= data.length) return null;
    return data[index];
  }

  /// Calculate the color for a cell based on its value and dynamic maxValue
  Color _getCellColor(
      {required double cellData,
      required num minValue,
      required num maxValue,
      required List<Color> gradientColors}) {
    // Normalize the cellData to a range of [0, 1]
    final double normalizedValue =
        ((cellData - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);

    // Interpolate the color from the gradient using HSV
    return _interpolateColorHSV(normalizedValue, gradientColors);
  }

  /// Interpolate a color based on a normalized value using HSV
  Color _interpolateColorHSV(
      double normalizedValue, List<Color> gradientColors) {
    final int numberOfColors = gradientColors.length;
    final double scaledValue = normalizedValue * (numberOfColors - 1);
    final int lowerIndex = scaledValue.floor();
    final int upperIndex = scaledValue.ceil();

    if (lowerIndex == upperIndex) {
      return gradientColors[lowerIndex];
    }

    // Convert colors to HSV
    final HSVColor lowerColor = HSVColor.fromColor(gradientColors[lowerIndex]);
    final HSVColor upperColor = HSVColor.fromColor(gradientColors[upperIndex]);

    // Interpolate in the HSV space
    final double t = scaledValue - lowerIndex;
    final HSVColor interpolatedColor =
        HSVColor.lerp(lowerColor, upperColor, t)!;

    return interpolatedColor.toColor();
  }

  /// Calculate the rect for a cell based on its row and column
  Rect _getCellRect(int row, int col, double cellSizeWithPadding) {
    final double left = col * cellSizeWithPadding;
    final double top = row * cellSizeWithPadding;
    return Rect.fromLTWH(left, top, options.cellSize, options.cellSize);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Update this if dynamic updates are needed
  }
}
