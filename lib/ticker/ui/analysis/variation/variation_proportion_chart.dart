import 'dart:core';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:turing_deal/market_data/model/variation/variation_count.dart';

class VariationProportionChart extends StatelessWidget {
  final List<VariationCount> countByInterval;

  const VariationProportionChart(this.countByInterval);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _getData(),
      animate: false,
      vertical: false,
      // Left labels
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
              labelStyle: charts.TextStyleSpec(
                  fontSize: 12, color: charts.MaterialPalette.white),
              lineStyle:
                  charts.LineStyleSpec(color: charts.MaterialPalette.white))),
      // Top labels
      secondaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(
                  fontSize: 12, color: charts.MaterialPalette.white),
              lineStyle:
                  charts.LineStyleSpec(color: charts.MaterialPalette.white))),
    );
  }

  List<charts.Series<VariationCount, String>> _getData() {
    return [
      new charts.Series<VariationCount, String>(
          id: 'Data',
          domainFn: (VariationCount variationCount, _) =>
              variationCount.intervalDescription,
          measureFn: (VariationCount variationCount, _) =>
              variationCount.count.toInt(),
          data: countByInterval,
          labelAccessorFn: (VariationCount variationCount, _) =>
              '${variationCount.count}')
        // Set series to use the secondary measure axis.
        ..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId'),
    ];
  }
}
