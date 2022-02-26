import 'package:flutter/material.dart';
import 'package:turing_deal/shared/app_theme.dart';
import 'package:turing_deal/ticker/ui/chart/chart_legend_item.dart';

class ChartLegend extends StatelessWidget {
  const ChartLegend();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: 100,
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      color: Colors.black.withOpacity(0.5),
      child: Column(
        children: [
          ChartLegendItem(AppTheme.ma20, "SMA_20"),
          ChartLegendItem(AppTheme.ma50, "SMA_50"),
          ChartLegendItem(AppTheme.ma200, "SMA_200"),
        ],
      ),
    );
  }
}
