import 'package:flutter/material.dart';
import 'package:flutter_git_graph/data/data_export.dart';
import 'package:flutter_git_graph/utils/utils_export.dart';

class HomeScreenViewModel extends ChangeNotifier {

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HomeScreenViewModel(){
    fetchYearData();
  }

  final ValueNotifier<List<DayData>> _currentData = ValueNotifier([]);
  ValueNotifier<List<DayData>> get currentData => _currentData;

  final ValueNotifier<List<double?>> _currentHeatmapData = ValueNotifier([]);
  ValueNotifier<List<double?>> get currentHeatmapData => _currentHeatmapData;

  final ValueNotifier<List<String>> _monthLabels = ValueNotifier([]);
  ValueNotifier<List<String>> get monthLabels => _monthLabels;

  void fetchYearData() {
    _isLoading = true;
    final data = MockData.generateYearMockData();
    _currentData.value = data;
    _currentHeatmapData.value = DayData.transformToHeatmap(data);
    _updateMonthLabels(data);
    _isLoading = false;
    notifyListeners();
  }

  void _updateMonthLabels(List<DayData> data) {
    if (data.isEmpty) {
      _monthLabels.value = [];
      return;
    }

    final dates = data.map((day) => DateTime.parse(day.date)).toList()
      ..sort((a, b) => a.compareTo(b));

    final startDate = dates.first;
    final endDate = dates.last;
    _monthLabels.value = _generateMonthLabels(startDate, endDate);
  }

  List<String> _generateMonthLabels(DateTime startDate, DateTime endDate) {
    final labels = <String>[];
    const monthNames = AppConstants.monthLabels;
    
    // Start from the first day of the start month
    var currentDate = DateTime(startDate.year, startDate.month);
    final lastDate = DateTime(endDate.year, endDate.month);

    while (currentDate.isBefore(lastDate) || 
           currentDate.month == lastDate.month) {
      // Only add label if we have data for this month
      if (_hasDataForMonth(currentDate)) {
        labels.add(monthNames[currentDate.month - 1]);
      }
      currentDate = DateTime(
        currentDate.year, 
        currentDate.month + 1
      );
    }

    return labels;
  }

  bool _hasDataForMonth(DateTime date) {
    return _currentData.value.any((dayData) {
      final dataDate = DateTime.parse(dayData.date);
      return dataDate.year == date.year && 
             dataDate.month == date.month;
    });
  }

  @override
  void dispose() {
    _currentData.dispose();
    _currentHeatmapData.dispose();
    _monthLabels.dispose();
    super.dispose();
  }
}
