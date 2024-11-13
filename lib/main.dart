import 'package:flutter/material.dart';
import 'package:flutter_git_graph/heatmap/heatmap_exports.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Controlled Grid Placement')),
        body: HeatmapWidget(
          options: HeatmapOptions(
            maxColumns: 54,
            maxRows: 7
          ),
          data: [
            [0.1, 0.3, 0.5, 0.7, 0.9],
            [
              0.2,
              0.4,
              0.6,
              0.8,
              1.0,
              0.2,
              0.4,
              0.6,
              0.8,
              1.0,
              0.2,
              0.4,
              0.6,
              0.8,
              1.0,
              0.2,
              0.4,
              0.6,
              0.8,
              1.0,
              0.2,
              0.4,
              0.6,
              0.8,
              1.0,
              0.2,
              0.4,
              0.6,
              0.8,
              0.2,
              0.4,
              0.6,
              0.8,
              1.0,
              0.2,
              0.4,
              0.6,
              0.8,
              1.0,
              0.2,
              0.4,
              0.6,
              0.8,
              0.2,
              0.4,
              0.6,
              0.8,
              1.0,
              0.2,
              0.4,
              0.6,
              0.8,
              1.0,
              0.2,
              0.4,
              0.6,
              0.8,
              0.2,
              0.4,
              0.6,
              0.8,
              1.0,
              0.2,
              0.4,
              0.6,
              0.8,
              1.0,
              0.8,
              1.0,
              0.2,
              0.4,
              0.6,
              0.8,
              1.0,
              0.2,
              0.4,
              0.6,
              0.8,
              1.0
            ],
            [0.2, 0.4, 0.6, 0.8, 1.0],
            [0.2, 0.4, 0.6, 0.8, 1.0],
            [0.2, 0.4, 0.6, 0.8, 1.0],
            [0.2, 0.4, 0.6, 0.8, 1.0],
            [0.3, 0.5, 0.7, 0.9, 0.6],
          ],
          xLabels: ['Mon', 'Wed', 'Tues'],
          yLabels: ['Wed', 'Fri', 'Sat'],
        ),
      ),
    );
  }
}

// Enum to handle axis position
enum AxisPosition { top, bottom, left, right }
