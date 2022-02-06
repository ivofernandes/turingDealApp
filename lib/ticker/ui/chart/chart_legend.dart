import 'package:flutter/material.dart';
import 'package:turing_deal/shared/app_theme.dart';

class ChartLegend extends StatelessWidget {
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

class ChartLegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const ChartLegendItem(this.color, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 5,
          width: 5,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(text)
      ],
    );
  }
}
