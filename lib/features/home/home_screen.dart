import 'package:flutter/material.dart';
import 'package:flutter_git_graph/app_state/app_state_provider.dart';
import 'package:flutter_git_graph/features/home/home_vm.dart';
import 'package:flutter_git_graph/heatmap/heatmap_exports.dart';
import 'package:flutter_git_graph/heatmap/ui/widgets/tooltip.dart';
import 'package:flutter_git_graph/utils/utils_export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeScreenVM = HomeScreenViewModel();

  @override
  void dispose() {
    _homeScreenVM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Screen',
          style: AppTextStyles.headingTextStyle.copyWith(
            color: ColorUtil.colorWhite,
          ),
        ),
        backgroundColor: ColorUtil.primaryColor,
      ),
      body: AppState<HomeScreenViewModel>(
        state: _homeScreenVM,
        child: ValueListenableBuilder(
          valueListenable: _homeScreenVM.currentData,
          builder: (ctx, data, child) {
            return ValueListenableBuilder(
              valueListenable: _homeScreenVM.monthLabels,
              builder: (ctx, monthLabels, child) {
                if (_homeScreenVM.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HeatmapWidget(
                    options: const HeatmapOptions(
                      maxColumns: 54,
                      maxRows: 7,
                      maxValueForFullColor: 5,
                      minValueForEmptyState: 0,
                    ),
                    data: data,
                    xLabels: monthLabels,
                    yLabels: AppConstants.dayLabels,
                    tooltipBuilder: (value) {
                      return TransactionTooltip(dayData: value);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _homeScreenVM.fetchYearData();
        },
        child: const Icon(Icons.calendar_today),
      ),
    );
  }
}
