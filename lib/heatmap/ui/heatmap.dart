import 'package:flutter/material.dart';

import 'heatmap_options.dart';
import 'custom_graph.dart';

class HeatmapWidget<T> extends StatelessWidget {
  //nullable to add empty cells
  final List<List<T?>> data;
  final List<String> xLabels;
  final List<String> yLabels;
  final HeatmapOptions options;
  final Widget Function(T data, int row, int col)? tooltipBuilder;

  const HeatmapWidget({
    super.key,
    required this.data,
    required this.xLabels,
    required this.yLabels,
    this.options = const HeatmapOptions(),
    this.tooltipBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the number of rows and columns based on user input or data length
        final int maxColumns = options.maxColumns ?? data.length;
        final int maxRows = options.maxRows ?? data.length;

        // Calculate total width and height based on the number of rows/columns
        final double totalWidth = maxColumns * (options.cellSize + options.cellPadding);
        final double totalHeight = maxRows * (options.cellSize + options.cellPadding);

        // X-axis labels as a row
        Widget xAxisLabels = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: xLabels
              .map((label) => SizedBox(
            width: options.cellSize,
            height: 24,
            child: Center(child: Text(label)),
          ))
              .toList(),
        );

        // Y-axis labels as a column
        Widget yAxisLabels = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: yLabels
              .map((label) => SizedBox(
            width: 24, // Width for y-axis labels
            height: options.cellSize,
            child: Center(child: Text(label)),
          ))
              .toList(),
        );

        // Heatmap with custom painting, positioned based on dynamic constraints
        Widget heatmap = Padding(
          padding: options.graphPadding,
          child: CustomPaint(
            size: Size(totalWidth, totalHeight),
            painter: HeatmapPainter(data, options),
          ),
        );

        // Combine elements based on axis positions
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              if (options.xAxisPosition == HeatmapAxisPosition.top) xAxisLabels,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (options.yAxisPosition == HeatmapAxisPosition.left) yAxisLabels,
                  heatmap,
                  if (options.yAxisPosition == HeatmapAxisPosition.right) yAxisLabels,
                ],
              ),
              if (options.xAxisPosition == HeatmapAxisPosition.bottom) xAxisLabels,
            ],
          ),
        );
      },
    );
  }
}
