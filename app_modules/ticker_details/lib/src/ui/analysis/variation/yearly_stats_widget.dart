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
            height: tickerState.getYearlyStats().length * 40,
            width: MediaQuery.of(context).size.width - 100,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(tickerState.getYearlyStats()),
                barGroups: _getBarGroups(tickerState.getYearlyStats()),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                      reservedSize: 40,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          tickerState.getYearlyStats()[value.toInt()].year.toString(),
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        );
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
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.blue.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.blue.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.round()}',
                        TextStyle(color: Colors.white),
                      );
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

  double _getMaxY(List<YearlyStats> yearlyStats) {
    double max = 0;
    for (var stat in yearlyStats) {
      if (stat.variation > max) max = stat.variation;
      if (stat.drawdown > max) max = stat.drawdown;
    }
    return max;
  }

  List<BarChartGroupData> _getBarGroups(List<YearlyStats> yearlyStats) {
    return yearlyStats.asMap().entries.map((entry) {
      int index = entry.key;
      YearlyStats yearlyStat = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: yearlyStat.variation,
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreenAccent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 15,
            borderRadius: BorderRadius.circular(6),
          ),
          BarChartRodData(
            toY: yearlyStat.drawdown,
            gradient: LinearGradient(
              colors: [Colors.red, Colors.orangeAccent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 15,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
        showingTooltipIndicators: [0, 1],
      );
    }).toList();
  }
}
