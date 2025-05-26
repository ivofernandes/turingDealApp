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
  Widget build(BuildContext context) => LineChart(
        LineChartData(
          lineBarsData: _getLineBarsData(),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: _getInterval(),
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(0),
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
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final showValue = value == meta.min || value == meta.max || value == (meta.max / 2).round();
                  if (!showValue) {
                    return Container();
                  }
                  final interval = countByInterval[value.toInt()];
                  return Text(
                    interval.intervalDescription,
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
            ),
          ),
          gridData: FlGridData(
            show: true,
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
            ),
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (touchedSpots) => touchedSpots.map((touchedSpot) {
                final interval = countByInterval[touchedSpot.x.toInt()];
                final String description = interval.intervalDescription;
                return LineTooltipItem(
                  '$description happened ${touchedSpot.y.toStringAsFixed(0)} times',
                  const TextStyle(color: Colors.white),
                );
              }).toList(),
            ),
          ),
        ),
      );

  double _getMaxY() {
    double max = 0;
    for (final VariationCount stat in countByInterval) {
      if (stat.count > max) {
        max = stat.count.toDouble();
      }
    }
    return max;
  }

  double _getInterval() {
    final double maxY = _getMaxY();
    return (maxY / 5).ceilToDouble();
  }

  List<LineChartBarData> _getLineBarsData() {
    final List<FlSpot> spots = [];

    for (int i = 0; i < countByInterval.length; i++) {
      spots.add(FlSpot(i.toDouble(), countByInterval[i].count.toDouble()));
    }

    return [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        color: Colors.blue,
        barWidth: 4,
        belowBarData: BarAreaData(),
      ),
    ];
  }
}
