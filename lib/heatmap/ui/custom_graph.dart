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

    // Paint cells column by column (column-major order)
    for (int col = 0; col < options.maxColumns; col++) {
      for (int row = 0; row < options.maxRows; row++) {
        final num? cellData = _getCellData(row, col);
        
        // Only draw cells that have data (not null)
        if (cellData != null) {
          paint.color = _getCellColor(cellData);
          final Rect rect = _getCellRect(row, col, cellSizeWithPadding);
          
          if (rect.left < size.width && rect.right > 0 &&
              rect.top < size.height && rect.bottom > 0) {
            final RRect rRect = RRect.fromRectAndRadius(rect, options.cellRadius);
            canvas.drawRRect(rRect, paint);
          }
        }
      }
    }
  }

  /// Get the data for a specific cell using column-major order
  num? _getCellData(int row, int col) {
    final int index = col * options.maxRows + row;
    if (index < 0 || index >= data.length) return null;
    return data[index];
  }

  /// Calculate the color for a cell based on its value
  Color _getCellColor(num cellData) {
    if (cellData == 0) {
      return options.emptyStateColor; // Empty state color for zero values
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
