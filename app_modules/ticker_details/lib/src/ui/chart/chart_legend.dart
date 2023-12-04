import 'package:flutter/material.dart';
import 'package:td_ui/td_ui.dart';
import 'package:ticker_details/src/ui/chart/chart_legend_item.dart';

class ChartLegend extends StatelessWidget {
  const ChartLegend();

  @override
  Widget build(BuildContext context) => Container(
        height: 75,
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        color: Colors.black.withOpacity(0.5),
        child: Column(
          children: [
            ChartLegendItem(AppTheme.ma20, 'SMA_20'),
            ChartLegendItem(AppTheme.ma50, 'SMA_50'),
            ChartLegendItem(AppTheme.ma200, 'SMA_200'),
          ],
        ),
      );
}
