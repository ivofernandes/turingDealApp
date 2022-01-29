import 'dart:core';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:turing_deal/market_data/model/variation/variation_count.dart';

class VariationPorportionChart extends StatelessWidget {
  final List<VariationCount> countByInterval;

  VariationPorportionChart(this.countByInterval);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _getData(),
      animate: false,
      vertical: false,
      // Left labels
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
        id: 'Global Revenue',
        domainFn: (VariationCount variationCount, _) =>
            variationCount.intervalDescription,
        measureFn: (VariationCount variationCount, _) =>
            variationCount.count.toInt(),
        data: countByInterval,
      )
        // Set series to use the secondary measure axis.
        ..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId'),
    ];
  }
}
