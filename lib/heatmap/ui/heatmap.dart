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

  DayData? _getCellDataAtOffset(Offset? offset, {bool forTooltip = false}) {
    if (offset == null) return null;

    final double cellSizeWithPadding =
        widget.options.cellSize + widget.options.cellPadding;

    // For tooltip, use screen position. For cell detection, use scrolled position
    double effectiveX;
    if (forTooltip) {
      // For tooltip, add scroll offset back to get original position
      effectiveX = offset.dx + _scrollController.offset;
    } else {
      // For cell detection, use the raw position
      effectiveX = offset.dx;
    }

    // Remove padding and calculate indices
    final adjustedX = effectiveX - widget.options.graphPadding.left;
    final adjustedY = offset.dy - widget.options.graphPadding.top;

    // Calculate cell indices
    final int col = (adjustedX / cellSizeWithPadding).floor();
    final int row = (adjustedY / cellSizeWithPadding).floor();

    // Validate bounds
    if (row < 0 ||
        row >= widget.options.maxRows ||
        col < 0 ||
        col >= widget.options.maxColumns) {
      //TODO: handle exception
      return null;
    }

    // Calculate index using column-major order
    final int index = col * widget.options.maxRows + row;
    
    // Only return data if the index exists and has non-null data
    if (index < widget.data.length) {
      return widget.data[index];
    }

    return null;
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
                          final RenderBox box = context.findRenderObject() as RenderBox;
                          final localPosition = box.globalToLocal(details.globalPosition);

                          // Get cell data using the local position
                          final cellData = _getCellDataAtOffset(localPosition);
                          
                          if (cellData != null) {
                            // For tooltip, use screen position
                            final screenX = localPosition.dx;
                            final tooltipOffset = Offset(screenX, localPosition.dy);
                            
                            _viewModel.setSelectedCell(
                              tooltipOffset,
                              cellData: cellData,
                              scrollOffset: _scrollController.offset,
                            );
                          }
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
        // Tooltip overlay
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
                _getCellDataAtOffset(offset, forTooltip: true),
              ),
            );
          },
        ),
      ],
    );
  }
}
