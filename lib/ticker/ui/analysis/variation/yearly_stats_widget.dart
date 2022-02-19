import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/market_data/model/yearly_stats.dart';
import 'package:turing_deal/ticker/state/ticker_state_provider.dart';

class YearlyStatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TickerStateProvider tickerState =
        Provider.of<TickerStateProvider>(context, listen: false);

    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        InteractiveViewer(
          child: SizedBox(
              height: tickerState.getYearlyStats().length * 40,
              width: 300,
              child: charts.BarChart(
                _getData(tickerState.getYearlyStats()),
                animate: false,
                vertical: false,
                barGroupingType: charts.BarGroupingType.grouped,
                barRendererDecorator: new charts.BarLabelDecorator<String>(
                    insideLabelStyleSpec: charts.TextStyleSpec(
                        fontSize: 12,
                        color: charts.Color.fromHex(code: "#000000")),
                    outsideLabelStyleSpec: charts.TextStyleSpec(
                        fontSize: 12,
                        color: charts.Color.fromHex(code: "#FFFFFF"))),
                // Left labels
                domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                        labelStyle: charts.TextStyleSpec(
                            fontSize: 12, color: charts.MaterialPalette.white),
                        lineStyle: charts.LineStyleSpec(
                            color: charts.MaterialPalette.white))),
                // Top labels
                secondaryMeasureAxis: charts.NumericAxisSpec(
                    renderSpec: charts.GridlineRendererSpec(
                        labelStyle: charts.TextStyleSpec(
                            fontSize: 12, color: charts.MaterialPalette.white),
                        lineStyle: charts.LineStyleSpec(
                            color: charts.MaterialPalette.white))),
              )),
        ),
      ],
    );
  }

  List<charts.Series<YearlyStats, String>> _getData(
      List<YearlyStats> yearlyStats) {
    return [
      new charts.Series<YearlyStats, String>(
          id: 'CAGR',
          displayName: 'CAGR',
          domainFn: (YearlyStats yearlyStat, _) => yearlyStat.year.toString(),
          measureFn: (YearlyStats yearlyStat, _) => yearlyStat.variation,
          data: yearlyStats,
          fillColorFn: (_, __) => charts.MaterialPalette.white,
          labelAccessorFn: (YearlyStats yearlyStat, _) =>
              '${yearlyStat.variation.toStringAsFixed(0)} %')
        ..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId'),
      new charts.Series<YearlyStats, String>(
          id: 'Drawdown',
          domainFn: (YearlyStats yearlyStat, _) => yearlyStat.year.toString(),
          measureFn: (YearlyStats yearlyStat, _) => yearlyStat.drawdown,
          data: yearlyStats,
          insideLabelStyleAccessorFn: (YearlyStats yearlyStat, _) =>
              charts.TextStyleSpec(
                  fontSize: 12, color: charts.Color.fromHex(code: "#000000")),
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
}
