import 'package:app_dependencies/app_dependencies.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:td_ui/td_ui.dart';
import 'package:ticker_details/src/state/ticker_state_provider.dart';
import 'package:ticker_details/src/ui/chart/chart_legend_item.dart';

class YearlyStatsWidget extends StatelessWidget {
  static const int _windowSize = 4; // 4-year window

  @override
  Widget build(BuildContext context) {
    final tickerState = Provider.of<TickerStateProvider>(context, listen: false);
    final yearlyStats = tickerState.getYearlyStats();
    if (yearlyStats.isEmpty) {
      return const Text('No data');
    }

    // 1) Prepare main data spots using the actual year on X:
    final List<FlSpot> cagrSpots = [];
    final List<FlSpot> drawdownSpots = [];

    // e.g. if your earliest year is 2000, you can do offsetYear = 2000 to make the x-values smaller
    // but let's just use the actual year as is:
    for (int i = 0; i < yearlyStats.length; i++) {
      final year = yearlyStats[i].year.toDouble();
      cagrSpots.add(FlSpot(year, yearlyStats[i].variation));
      drawdownSpots.add(FlSpot(year, yearlyStats[i].drawdown));
    }

    // 2) Compute partial 4yr moving averages but also store them with x=the actual year
    final cagrMovingAvg = _computeMovingAveragePartial(cagrSpots, _windowSize);
    final drawdownMovingAvg = _computeMovingAveragePartial(drawdownSpots, _windowSize);

    // 3) Build the line series
    final lineBarsData = [
      // Raw CAGR
      LineChartBarData(
        spots: cagrSpots,
        isCurved: true,
        color: AppTheme.brand,
        barWidth: 3,
        belowBarData: BarAreaData(show: true),
      ),
      // Raw Drawdown
      LineChartBarData(
        spots: drawdownSpots,
        isCurved: true,
        color: AppTheme.error,
        barWidth: 3,
        belowBarData: BarAreaData(show: true),
      ),
      // CAGR 4yr MA
      LineChartBarData(
        spots: cagrMovingAvg,
        isCurved: true,
        color: AppTheme.brand.withOpacity(0.6),
        barWidth: 2,
        dashArray: [8, 4],
      ),
      // Drawdown 4yr MA
      LineChartBarData(
        spots: drawdownMovingAvg,
        isCurved: true,
        color: AppTheme.error.withOpacity(0.6),
        barWidth: 2,
        dashArray: [8, 4],
      ),
    ];

    // 4) Compute min/max Y
    final allYValues = [
      ...cagrSpots.map((e) => e.y),
      ...drawdownSpots.map((e) => e.y),
    ];
    final yMin = allYValues.reduce((a, b) => a < b ? a : b);
    final yMax = allYValues.reduce((a, b) => a > b ? a : b);
    final range = (yMax - yMin).abs();
    final step = range == 0 ? 1 : range / 5;

    // 5) X axis range from firstYear..lastYear
    final xMin = cagrSpots.first.x; // or drawdownSpots.first.x, same
    final xMax = cagrSpots.last.x; // assume data is sorted by year

    return Column(
      children: [
        const SizedBox(height: 20),
        // Legend
        Column(
          children: [
            ChartLegendItem(AppTheme.brand, 'CAGR'),
            ChartLegendItem(AppTheme.error, 'Drawdown'),
            ChartLegendItem(AppTheme.brand.withOpacity(0.6), 'CAGR 4yr MA'),
            ChartLegendItem(AppTheme.error.withOpacity(0.6), 'Drawdown 4yr MA'),
            const SizedBox(height: 20),
          ],
        ),
        TouchInteractiveViewer(
          child: SizedBox(
            height: 400,
            width: MediaQuery.of(context).size.width - 50,
            child: LineChart(
              LineChartData(
                minX: xMin,
                maxX: xMax,
                minY: yMin,
                maxY: yMax,
                lineBarsData: lineBarsData,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: step.toDouble(),
                      reservedSize: 48,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12, color: Colors.blue),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      // Show a label roughly every 2 or 3 years:
                      interval: 2,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        // e.g. show integer year only
                        final yearInt = value.round();
                        // If you only want to show for certain intervals:
                        if (yearInt % 2 == 0) {
                          return Text(
                            '$yearInt',
                            style: const TextStyle(fontSize: 12, color: Colors.blue),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                ),
                borderData: FlBorderData(show: true),
                gridData: FlGridData(
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.blue.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.blue.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipItems: (touchedSpots) {
                      // If no spots touched, return empty
                      if (touchedSpots.isEmpty) return [];

                      // Suppose the first spot’s x is the “year”
                      final year = touchedSpots[0].x.round();

                      // We must return EXACTLY touchedSpots.length items
                      return touchedSpots.asMap().entries.map((entry) {
                        final i = entry.key;
                        final spot = entry.value;
                        final barIndex = spot.barIndex;

                        // If you want to label each line differently:
                        String seriesLabel;
                        switch (barIndex) {
                          case 0:
                            seriesLabel = 'CAGR';
                            break;
                          case 1:
                            seriesLabel = 'Drawdown';
                            break;
                          case 2:
                            seriesLabel = 'CAGR 4yr MA';
                            break;
                          default:
                            seriesLabel = 'Drawdown 4yr MA';
                        }

                        final yVal = spot.y.toStringAsFixed(2);

                        // If it's the first item, prefix with "Year: ..."
                        final prefix = (i == 0) ? 'Year: $year\n' : '';
                        final text = '$prefix$seriesLabel: $yVal%';

                        return LineTooltipItem(
                          text,
                          const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// A partial moving average that uses the actual X-values as well.
  /// For index i, average from i..i+windowSize-1 (or until the end).
  /// Then place the new point at the same X as the *middle* or *end* of that window.
  /// This example uses the "end" approach for clarity.
  List<FlSpot> _computeMovingAveragePartial(List<FlSpot> spots, int windowSize) {
    if (spots.isEmpty) return [];

    final result = <FlSpot>[];
    final n = spots.length;

    for (int i = 0; i < n; i++) {
      double sum = 0;
      int count = 0;
      for (int j = i; j < i + windowSize && j < n; j++) {
        sum += spots[j].y;
        count++;
      }
      final avg = sum / count;

      // place the new X at the last item in that window, e.g. spots[i+count-1].x
      final lastIndex = i + count - 1;
      final xVal = spots[lastIndex].x;

      result.add(FlSpot(xVal, avg));
      if (i + windowSize - 1 >= n - 1) {
        // If we've reached near the end, we can break, or continue if you want a partial at every step
      }
    }
    return result;
  }
}
