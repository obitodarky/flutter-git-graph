import 'package:flutter/material.dart';
import 'package:flutter_git_graph/heatmap/ui/heatmap_options.dart';
import 'package:flutter_git_graph/utils/utils_export.dart';

class HeatmapPainter<T> extends CustomPainter {
  final List<List<T?>> data; // The actual data
  final HeatmapOptions options;

  HeatmapPainter(this.data, this.options);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill;

    final double cellSize = options.cellSize;
    final double padding = options.cellPadding;
    final double cellWidth = cellSize;
    final double cellHeight = cellSize;

    // Loop through the grid and paint cells
    for (int row = 0; row < options.maxRows!; row++) {
      for (int col = 0; col < options.maxColumns!; col++) {
        // Check if there is data for this cell (data might be missing)
        final T? cellData = row < data.length && col < data[row].length ? data[row][col] : null;

        // If data exists, use filled state color, otherwise empty state color
        paint.color = cellData != null ? options.filledStateColor : options.emptyStateColor;

        // Calculate the position for the cell (taking padding into account)
        final double left = col * (cellWidth + padding);
        final double top = row * (cellHeight + padding);

        // Create a Rect object representing the cell
        final Rect cellRect = Rect.fromLTWH(left, top, cellWidth, cellHeight);

        // Draw the cell (filled or empty)
        canvas.drawRect(cellRect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // We can optimize repainting if necessary
  }
}


