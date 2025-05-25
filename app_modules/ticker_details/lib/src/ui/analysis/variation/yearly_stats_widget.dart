import 'package:app_dependencies/app_dependencies.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:td_ui/td_ui.dart';
import 'package:ticker_details/src/state/ticker_state_provider.dart';
import 'package:ticker_details/src/ui/chart/chart_legend_item.dart';

class YearlyStatsWidget extends StatefulWidget {
  const YearlyStatsWidget({Key? key}) : super(key: key);

  @override
  _YearlyStatsWidgetState createState() => _YearlyStatsWidgetState();
}

class _YearlyStatsWidgetState extends State<YearlyStatsWidget> {
  /// We allow toggling among 2, 4, and 8-year moving averages
  final List<int> possibleWindows = [2, 4, 8];
  int currentWindowIndex = 1; // default to "4-year"

  @override
  Widget build(BuildContext context) {
    final tickerState = Provider.of<TickerStateProvider>(context, listen: false);
    final yearlyStats = tickerState.getYearlyStats();

    if (yearlyStats.isEmpty) {
      return const Center(child: Text('No data'));
    }

    // EXAMPLE: filter to only show last 40 years if you want
    final cutoffYear = DateTime.now().year - 40; // last 40 years
    final filteredStats = yearlyStats.where((s) => s.year >= cutoffYear).toList();
    if (filteredStats.isEmpty) {
      return Text('No data after year $cutoffYear');
    }

    // 1) Prepare raw spots (CAGR and Drawdown)
    final cagrSpots = <FlSpot>[];
    final drawdownSpots = <FlSpot>[];

    for (final stat in filteredStats) {
      final yearDouble = stat.year.toDouble();
      cagrSpots.add(FlSpot(yearDouble, stat.variation));
      drawdownSpots.add(FlSpot(yearDouble, stat.drawdown));
    }

    // 2) Compute partial MAs for the chosen window
    final windowSize = possibleWindows[currentWindowIndex];
    final cagrMA = _computeMovingAveragePartial(cagrSpots, windowSize);
    final drawdownMA = _computeMovingAveragePartial(drawdownSpots, windowSize);

    // 3) Build line series
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
      // CAGR MA
      LineChartBarData(
        spots: cagrMA,
        isCurved: true,
        color: AppTheme.brand.withAlpha(153),
        barWidth: 2,
        dashArray: [8, 4],
      ),
      // Drawdown MA
      LineChartBarData(
        spots: drawdownMA,
        isCurved: true,
        color: AppTheme.error.withAlpha(153),
        barWidth: 2,
        dashArray: [8, 4],
      ),
    ];

    // 4) min/max X and Y
    final xMin = cagrSpots.first.x;
    final xMax = cagrSpots.last.x;

    // for Y:
    final allY = [
      ...cagrSpots.map((e) => e.y),
      ...drawdownSpots.map((e) => e.y),
    ];
    final yMin = allY.reduce((a, b) => a < b ? a : b);
    final yMax = allY.reduce((a, b) => a > b ? a : b);
    final range = (yMax - yMin).abs();
    final step = range == 0 ? 1 : range / 5;

    // legend label e.g. "MA(4yr)"
    final maLabel = 'MA(${windowSize}yr)';

    return SizedBox(
      height: 300, // fixed height for the chart area
      child: Column(
        children: [
          // Legend row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChartLegendItem(AppTheme.brand, 'CAGR'),
                  const SizedBox(width: 15),
                  ChartLegendItem(AppTheme.error, 'Drawdown'),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: _cycleWindow,
                    child: ChartLegendItem(
                      AppTheme.brand.withAlpha(153),
                      'CAGR $maLabel',
                    ),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: _cycleWindow,
                    child: ChartLegendItem(
                      AppTheme.error.withAlpha(153),
                      'Drawdown $maLabel',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                            value.toStringAsFixed(2), // fewer decimals
                            style: const TextStyle(fontSize: 12, color: Colors.blue),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        // We compute an interval based on how many years we have
                        interval: _autoComputeYearInterval(xMin, xMax),
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          final yearInt = value.round();
                          return Text(
                            '$yearInt',
                            style: const TextStyle(fontSize: 12, color: Colors.blue),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                  ),
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(
                    getDrawingVerticalLine: (val) => FlLine(
                      color: Colors.blue.withOpacity(0.1),
                      strokeWidth: 1,
                    ),
                    getDrawingHorizontalLine: (val) => FlLine(
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
                        if (touchedSpots.isEmpty) {
                          return [];
                        }
                        final year = touchedSpots[0].x.round();
                        return touchedSpots.asMap().entries.map((entry) {
                          final i = entry.key;
                          final spot = entry.value;
                          final barIndex = spot.barIndex;

                          String seriesLabel;
                          switch (barIndex) {
                            case 0:
                              seriesLabel = 'CAGR';
                              break;
                            case 1:
                              seriesLabel = 'Drawdown';
                              break;
                            case 2:
                              seriesLabel = 'CAGR $maLabel';
                              break;
                            default:
                              seriesLabel = 'Drawdown $maLabel';
                          }
                          final yVal = spot.y.toStringAsFixed(2);
                          final prefix = (i == 0) ? 'Year: $year\n' : '';
                          return LineTooltipItem(
                            '$prefix$seriesLabel: $yVal%',
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
      ),
    );
  }

  void _cycleWindow() {
    setState(() {
      currentWindowIndex = (currentWindowIndex + 1) % possibleWindows.length;
    });
  }

  /// Partial moving average, e.g. 4-year, with the last point's X
  List<FlSpot> _computeMovingAveragePartial(List<FlSpot> spots, int windowSize) {
    final result = <FlSpot>[];
    for (int i = 0; i < spots.length; i++) {
      double sum = 0;
      int count = 0;
      for (int j = i; j < i + windowSize && j < spots.length; j++) {
        sum += spots[j].y;
        count++;
      }
      final avg = sum / count;
      final lastIndex = i + count - 1;
      final xVal = spots[lastIndex].x;
      result.add(FlSpot(xVal, avg));
      if (i + windowSize - 1 >= spots.length - 1) {
        break;
      }
    }
    return result;
  }

  /// Compute a decent interval for the bottom axis, based on how many years in [xMin, xMax].
  double _autoComputeYearInterval(double xMin, double xMax) {
    final totalYears = (xMax - xMin).abs();
    // For example, if totalYears < 20, show every year; else show every 5 years, etc.
    if (totalYears < 20) {
      return 1;
    }
    if (totalYears < 40) {
      return 2;
    }
    if (totalYears < 80) {
      return 5;
    }
    return 10;
  }
}
