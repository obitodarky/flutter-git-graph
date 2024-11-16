import 'package:flutter/material.dart';
import 'package:flutter_git_graph/data/data_export.dart';
import 'package:flutter_git_graph/heatmap/heatmap_exports.dart';
import 'package:flutter_git_graph/heatmap/ui/view_model.dart';
import 'package:flutter_git_graph/utils/utils_export.dart';

import 'custom_graph.dart';

class HeatmapWidget extends StatefulWidget {
  final List<DayData> data; // Nullable for empty cells
  final List<String> xLabels;
  final List<String> yLabels;
  final HeatmapOptions options;
  final Widget Function(DayData? data)? tooltipBuilder;

  const HeatmapWidget({
    super.key,
    required this.data,
    required this.xLabels,
    required this.yLabels,
    required this.options,
    this.tooltipBuilder,
  });

  @override
  State<HeatmapWidget> createState() => _HeatmapWidgetState();
}

class _HeatmapWidgetState extends State<HeatmapWidget> {
  final HeatmapViewModel _viewModel = HeatmapViewModel();
  final _scrollController = ScrollController();

  Widget _buildMonthLabels() {
    final cellSizeWithPadding = widget.options.cellSize + widget.options.cellPadding;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(widget.options.maxColumns, (columnIndex) {
        // Check if this column starts a new month
        if (columnIndex * widget.options.maxRows < widget.data.length) {
          final dayData = widget.data[columnIndex * widget.options.maxRows];
          final date = DateTime.parse(dayData.date);
          
          // If it's the first day of the month or first column
          if (date.day <= 7 || columnIndex == 0) {
            return Text(
              AppConstants.monthLabels[date.month - 1],
              style: widget.options.xAxisTextStyle,
              overflow: TextOverflow.visible, // Add this to prevent truncation
            );
          }
        }
        
        // Return empty space for other columns
        return SizedBox(width: cellSizeWithPadding);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double cellSizeWithPadding = 
        widget.options.cellSize + widget.options.cellPadding;
    final double contentWidth = widget.options.maxColumns * cellSizeWithPadding;
    final double contentHeight = widget.options.maxRows * cellSizeWithPadding;

    // X-axis labels using Row instead of Stack
    Widget xAxisLabels = SizedBox(
      width: contentWidth,
      child: _buildMonthLabels(),
    );

    // Y-axis labels with equal spacing
    Widget yAxisLabels = SizedBox(
      height: contentHeight, // Match the graph content height
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          widget.yLabels.length,
          (index) => Text(
            widget.yLabels[index],
            textAlign: TextAlign.center,
            style: widget.options.yAxisTextStyle,
          ),
        ),
      ),
    );

    // Heatmap with custom painting
    Widget heatmap = Padding(
      padding: widget.options.graphPadding,
      child: CustomPaint(
        size: Size(contentWidth, contentHeight), // Use content dimensions
        painter: HeatmapPainter(
          data: DayData.transformToHeatmap(widget.data),
          options: widget.options,
        ),
      ),
    );

    return Stack(
      children: [
        // Scrollable heatmap content
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: Column(
            children: [
              // Top x-axis labels (if specified)
              if (widget.options.xAxisPosition == HeatmapAxisPosition.top)
                xAxisLabels,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left y-axis labels (if specified)
                  if (widget.options.yAxisPosition == HeatmapAxisPosition.left)
                    yAxisLabels,
                  ValueListenableBuilder(
                    valueListenable: _viewModel.onTapWidgetOffset,
                    builder: (context, offset, child) {
                      return GestureDetector(
                        onTapUp: (details) {
                          final cellData =
                              _getCellDataAtOffset(details.localPosition);
                          _viewModel.setSelectedCell(
                            details.localPosition,
                            cellData: cellData,
                            scrollOffset: _scrollController.offset,
                          );
                        },
                        child: heatmap,
                      );
                    },
                  ),
                  // Right y-axis labels (if specified)
                  if (widget.options.yAxisPosition == HeatmapAxisPosition.right)
                    yAxisLabels,
                ],
              ),
              // Bottom x-axis labels (if specified)
              if (widget.options.xAxisPosition == HeatmapAxisPosition.bottom)
                xAxisLabels,
            ],
          ),
        ),
        // Tooltip overlay if tapped
        ValueListenableBuilder<Offset?>(
          valueListenable: _viewModel.onTapWidgetOffset,
          builder: (context, offset, child) {
            if (offset == null) {
              return const SizedBox.shrink();
            }
            return Positioned(
              left: offset.dx + widget.options.graphPadding.left,
              top: offset.dy + widget.options.graphPadding.top,
              child: widget.tooltipBuilder!(
                _getCellDataAtOffset(offset),
              ),
            );
          },
        ),
      ],
    );
  }

  DayData? _getCellDataAtOffset(Offset? offset) {
    if (offset == null) return null;

    // Calculate cell size including padding
    final double cellSizeWithPadding =
        widget.options.cellSize + widget.options.cellPadding;

    // Adjust the offset for scrolling and padding
    final double scrollOffset = _scrollController.offset;
    final double adjustedX =
        offset.dx + scrollOffset - widget.options.graphPadding.left;
    final double adjustedY = offset.dy - widget.options.graphPadding.top;

    // Step 4: Calculate row and column indices
    final int col = (adjustedX / cellSizeWithPadding).floor();
    final int row = (adjustedY / cellSizeWithPadding).floor();

    // // Debug prints
    print('Tap offset: $offset');
    print('Scroll offset: $scrollOffset');
    print('Adjusted coordinates: ($adjustedX, $adjustedY)');
    print('Cell indices: row=$row, col=$col');

    // Validate if tap is within cell bounds (not in padding)
    final double cellX = adjustedX - (col * cellSizeWithPadding);
    final double cellY = adjustedY - (row * cellSizeWithPadding);

    if (cellX > widget.options.cellSize || cellY > widget.options.cellSize) {
      return null;
    }

    // Validate row and column bounds
    if (row < 0 ||
        row >= widget.options.maxRows ||
        col < 0 ||
        col >= widget.options.maxColumns) {
      return null;
    }

    // Calculate the index using column-major order
    final int index = col * widget.options.maxRows + row;
    if (index >= widget.data.length) {
      return null;
    }

    return widget.data[index];
  }
}
