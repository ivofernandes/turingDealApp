import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/market_data/model/yearly_stats.dart';
import 'package:turing_deal/shared/app_theme.dart';
import 'package:turing_deal/shared/ui/touch_interative_viewer.dart';
import 'package:turing_deal/ticker/state/ticker_state_provider.dart';
import 'package:turing_deal/ticker/ui/chart/chart_legend_item.dart';

class YearlyStatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TickerStateProvider tickerState =
        Provider.of<TickerStateProvider>(context, listen: false);

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
              child: charts.BarChart(
                _getData(tickerState.getYearlyStats()),
                animate: false,
                vertical: false,
                barGroupingType: charts.BarGroupingType.grouped,
                barRendererDecorator: charts.BarLabelDecorator<String>(
                    insideLabelStyleSpec: const charts.TextStyleSpec(
                        fontSize: 12, color: charts.MaterialPalette.black),
                    outsideLabelStyleSpec: const charts.TextStyleSpec(
                        fontSize: 12, color: charts.MaterialPalette.black)),
                // Left labels
                domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                        labelStyle: charts.TextStyleSpec(
                            fontSize: 12,
                            color: charts.MaterialPalette.blue.shadeDefault),
                        lineStyle: charts.LineStyleSpec(
                            color: charts.MaterialPalette.blue.shadeDefault))),
                // Top labels
                secondaryMeasureAxis: charts.NumericAxisSpec(
                    renderSpec: charts.GridlineRendererSpec(
                        labelStyle: charts.TextStyleSpec(
                            fontSize: 12,
                            color: charts.MaterialPalette.blue.shadeDefault),
                        lineStyle: charts.LineStyleSpec(
                            color: charts.MaterialPalette.blue.shadeDefault))),
              )),
        ),
      ],
    );
  }

  List<charts.Series<YearlyStats, String>> _getData(
      List<YearlyStats> yearlyStats) => [
      charts.Series<YearlyStats, String>(
          id: 'CAGR',
          displayName: 'CAGR',
          domainFn: (YearlyStats yearlyStat, _) => yearlyStat.year.toString(),
          measureFn: (YearlyStats yearlyStat, _) => yearlyStat.variation,
          data: yearlyStats,
          fillColorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          labelAccessorFn: (YearlyStats yearlyStat, _) =>
              '${yearlyStat.variation.toStringAsFixed(0)} %')
        ..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId'),
      charts.Series<YearlyStats, String>(
          id: 'Drawdown',
          domainFn: (YearlyStats yearlyStat, _) => yearlyStat.year.toString(),
          measureFn: (YearlyStats yearlyStat, _) => yearlyStat.drawdown,
          data: yearlyStats,
          insideLabelStyleAccessorFn: (YearlyStats yearlyStat, _) =>
              charts.TextStyleSpec(
                  fontSize: 12, color: charts.Color.fromHex(code: '#000000')),
          outsideLabelStyleAccessorFn: (YearlyStats yearlyStat, _) =>
              charts.TextStyleSpec(
                  fontSize: 12,
                  color: charts.MaterialPalette.red.shadeDefault.lighter),
          labelAccessorFn: (YearlyStats yearlyStat, _) =>
              '${yearlyStat.drawdown.toStringAsFixed(0)} %',
          fillColorFn: (_, __) =>
              charts.MaterialPalette.red.shadeDefault.lighter)
        ..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId'),
    ];
}
