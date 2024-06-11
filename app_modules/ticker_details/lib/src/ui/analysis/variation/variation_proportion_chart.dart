import 'dart:core';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stock_market_data/stock_market_data.dart';

class VariationProportionChart extends StatelessWidget {
  final List<VariationCount> countByInterval;

  const VariationProportionChart(
    this.countByInterval, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY(),
        barGroups: _getBarGroups(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                value.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              reservedSize: 30,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  countByInterval[value.toInt()].intervalDescription,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.toY.round().toString(),
                TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }

  double _getMaxY() {
    double max = 0;
    for (VariationCount stat in countByInterval) {
      if (stat.count > max) max = stat.count.toDouble();
    }
    return max;
  }

  List<BarChartGroupData> _getBarGroups() {
    return countByInterval.asMap().entries.map((entry) {
      int index = entry.key;
      VariationCount variationCount = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: variationCount.count.toDouble(),
            color: Colors.blue,
            width: 15,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }
}
