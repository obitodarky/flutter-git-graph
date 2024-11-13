import 'package:flutter/material.dart';

enum HeatmapAxisPosition { top, bottom, left, right }

class HeatmapOptions {
  // Cell Styling
  final double cellSize;
  final Color minColor;
  final Color maxColor;

  // Axis Styling
  final TextStyle xAxisTextStyle;
  final TextStyle yAxisTextStyle;
  final EdgeInsets axisPadding;

  final double cellPadding;
  final EdgeInsets graphPadding;

  // Axis Positioning
  final HeatmapAxisPosition xAxisPosition;
  final HeatmapAxisPosition yAxisPosition;

  // Heatmap Padding
  final EdgeInsets heatmapPadding;

  final Color emptyStateColor; // Color for empty cells
  final Color filledStateColor; // Color for filled cells

  final int? maxRows; // Max rows can be specified by the user
  final int? maxColumns; // Max columns can be specified by the user

  // Constructor with default styling and axis positioning
  const HeatmapOptions({
    this.minColor = Colors.lightBlueAccent,
    this.maxColor = Colors.blueAccent,
    this.cellSize = 20,
    this.maxRows,
    this.maxColumns,
    this.emptyStateColor = Colors.grey,
    this.filledStateColor = Colors.blue,
    this.graphPadding = const EdgeInsets.all(8.0),
    this.cellPadding = 2.0,
    this.xAxisTextStyle = const TextStyle(fontSize: 12, color: Colors.black),
    this.yAxisTextStyle = const TextStyle(fontSize: 12, color: Colors.black),
    this.axisPadding = const EdgeInsets.all(4.0),
    this.heatmapPadding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.xAxisPosition = HeatmapAxisPosition.top,
    this.yAxisPosition = HeatmapAxisPosition.left,
  });
}
