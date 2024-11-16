import 'package:flutter/material.dart';

class HeatmapViewModel<T> extends ChangeNotifier {

  final ValueNotifier<Offset?> _onTapWidgetOffset = ValueNotifier(
    null
  );

  ValueNotifier<Offset?> get onTapWidgetOffset => _onTapWidgetOffset;

  final ValueNotifier<T?> _selectedCellData = ValueNotifier(null);
  ValueNotifier<T?> get selectedCellData => _selectedCellData;

  Offset? setSelectedCell(Offset tapOffset, {required T? cellData, required double scrollOffset}) {
    if (_onTapWidgetOffset.value != null) {
      _clearData();
      return null;
    }
    
    if (cellData != null) {
      final adjustedOffset = Offset(
        tapOffset.dx + scrollOffset,
        tapOffset.dy,
      );
      _onTapWidgetOffset.value = adjustedOffset;
      _selectedCellData.value = cellData;
      notifyListeners();
      return adjustedOffset;
    }
    return null;
  }

  void _clearData(){
    _onTapWidgetOffset.value = null;
    _selectedCellData.value = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _onTapWidgetOffset.dispose();
    _selectedCellData.dispose();
    super.dispose();
  }

}
