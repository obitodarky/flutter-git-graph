import 'package:flutter/material.dart';
import 'package:flutter_git_graph/utils/color/color_util.dart';

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
  final Radius cellRadius;

  // Axis Positioning
  final HeatmapAxisPosition xAxisPosition;
  final HeatmapAxisPosition yAxisPosition;

  // Heatmap Padding
  final EdgeInsets heatmapPadding;

  final Color emptyStateColor; // Color for empty cells
  final Color filledStateColor; // Color for filled cells

  final double maxValueForFullColor;
  final double minValueForEmptyState;

  final List<Color> gradientColors;

  final int maxRows; // Max rows can be specified by the user
  final int maxColumns; // Max columns can be specified by the user

  // Constructor with default styling and axis positioning
  const HeatmapOptions({
    this.minColor = ColorUtil.colorGrey,
    this.maxColor = ColorUtil.primaryColor,
    this.cellSize = 20,
    required this.maxRows,
    this.cellRadius = const Radius.circular(2),
    required this.maxColumns,
    this.emptyStateColor = ColorUtil.colorGrey,
    this.maxValueForFullColor = 1,
    this.gradientColors =  ColorUtil.heatmapColors,
    this.minValueForEmptyState = 0,
    this.filledStateColor = ColorUtil.primaryColor,
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
