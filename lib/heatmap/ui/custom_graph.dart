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

    // Calculate visible columns based on size
    final double cellSizeWithPadding = options.cellSize + options.cellPadding;
    final int visibleColumns = (size.width / cellSizeWithPadding).ceil();
    
    // Ensure we don't exceed maxColumns
    final int columnsToRender = visibleColumns.clamp(0, options.maxColumns);

    // Loop through the grid and paint cells
    for (int row = 0; row < options.maxRows; row++) {
      for (int col = 0; col < columnsToRender; col++) {
        final num? cellData = _getCellData(row, col);
        paint.color = _getCellColor(cellData);

        final Rect rect = _getCellRect(row, col);
        // Only draw if the rect is within the canvas bounds
        if (rect.left < size.width && rect.right > 0 &&
            rect.top < size.height && rect.bottom > 0) {
          final RRect rRect = RRect.fromRectAndRadius(rect, options.cellRadius);
          canvas.drawRRect(rRect, paint);
        }
      }
    }
  }

  /// Get the data for a specific cell, calculate the index in the 1D list
  num? _getCellData(int row, int col) {
    //Column major vs Row Major?
    final int index = col * options.maxRows + row;
    if (index < 0 || index >= data.length) return null;
    return data[index];
  }

  /// Calculate the color for a cell based on its value
  Color _getCellColor(num? cellData) {
    if (cellData == null) {
      return options.emptyStateColor;
    }
    return _mapValueToColor(cellData.toDouble());
  }

  /// Map a value to the corresponding color in the gradient
  Color _mapValueToColor(double value) {
    // Get the number of color levels from gradientColors
    final int levels = options.gradientColors.length;
    
    // Calculate the range between min and max values
    final double valueRange = options.maxValueForFullColor - options.minValueForEmptyState;
    
    // Calculate the size of each level
    final double levelSize = valueRange / (levels - 1);

    // If value is at or below minimum, return first color
    if (value <= options.minValueForEmptyState) {
      return options.gradientColors.first;
    }
    
    // If value is at or above maximum, return last color
    if (value >= options.maxValueForFullColor) {
      return options.gradientColors.last;
    }

    // Calculate how far above minimum the value is
    final double valueAboveMin = value - options.minValueForEmptyState;
    
    // Calculate which level this value falls into
    final int levelIndex = (valueAboveMin / levelSize).floor();
    
    // Ensure we don't exceed array bounds
    final int safeIndex = levelIndex.clamp(0, levels - 1);
    
    return options.gradientColors[safeIndex];
  }

  /// Calculate the rect for a cell based on its row and column
  Rect _getCellRect(int row, int col) {
    final double left = col * (options.cellSize + options.cellPadding);
    final double top = row * (options.cellSize + options.cellPadding);
    return Rect.fromLTWH(left, top, options.cellSize, options.cellSize);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Update this if dynamic updates are needed
  }
}
