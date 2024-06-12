import 'package:app_dependencies/app_dependencies.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:td_ui/td_ui.dart';
import 'package:ticker_details/src/state/ticker_state_provider.dart';
import 'package:ticker_details/src/ui/chart/chart_legend_item.dart';

class YearlyStatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TickerStateProvider tickerState = Provider.of<TickerStateProvider>(context, listen: false);

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Column(
          children: [
            ChartLegendItem(AppTheme.brand, 'CAGR'),
            ChartLegendItem(Colors.red.shade200, 'Drawdown'),
            const SizedBox(height: 20)
          ],
        ),
        TouchInteractiveViewer(
          child: SizedBox(
            height: 400,
            width: MediaQuery.of(context).size.width - 50,
            child: LineChart(
              LineChartData(
                lineBarsData: _getLineBarsData(tickerState.getYearlyStats()),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      getTitlesWidget: (value, meta) {
                        if (value % 10 == 0) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          );
                        }
                        return Container();
                      },
                      reservedSize: 40,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final year = tickerState.getYearlyStats()[value.toInt()].year;
                        if (year % 10 == 0) {
                          return Text(
                            year.toString(),
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.blue,
                    width: 1,
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.blue.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.blue.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipItems: (touchedSpots) {
                      final year = tickerState.getYearlyStats()[touchedSpots[0].x.toInt()].year;
                      final cagr = touchedSpots[0].y;
                      final drawdown = touchedSpots[1].y;
                      return [
                        LineTooltipItem(
                          'Year: $year\nCAGR: ${cagr.toStringAsFixed(2)}%',
                          const TextStyle(color: Colors.white),
                        ),
                        LineTooltipItem(
                            'Drawdown: ${drawdown.toStringAsFixed(2)}%', const TextStyle(color: Colors.white)),
                      ];
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

  List<LineChartBarData> _getLineBarsData(List<YearlyStats> yearlyStats) {
    final List<FlSpot> cagrSpots = [];
    final List<FlSpot> drawdownSpots = [];

    for (int i = 0; i < yearlyStats.length; i++) {
      cagrSpots.add(FlSpot(i.toDouble(), yearlyStats[i].variation));
      drawdownSpots.add(FlSpot(i.toDouble(), yearlyStats[i].drawdown));
    }

    return [
      LineChartBarData(
        spots: cagrSpots,
        isCurved: true,
        color: AppTheme.brand,
        barWidth: 4,
        belowBarData: BarAreaData(show: false),
      ),
      LineChartBarData(
        spots: drawdownSpots,
        isCurved: true,
        color: AppTheme.error,
        barWidth: 4,
        belowBarData: BarAreaData(show: false),
      ),
    ];
  }
}
