import 'dart:core';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:stock_market_data/stock_market_data.dart';

class VariationProportionChart extends StatelessWidget {
  final List<VariationCount> countByInterval;

  const VariationProportionChart(
    this.countByInterval, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => charts.BarChart(
        _getData(),
        animate: false,
        vertical: false,
        // Left labels
        barRendererDecorator: charts.BarLabelDecorator<String>(
          insideLabelStyleSpec: const charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.white,
          ),
          outsideLabelStyleSpec: const charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.white,
          ),
        ),
        domainAxis: const charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
            labelStyle: charts.TextStyleSpec(
              fontSize: 12,
              color: charts.MaterialPalette.white,
            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.white,
            ),
          ),
        ),
        // Top labels
        secondaryMeasureAxis: const charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
                fontSize: 12, color: charts.MaterialPalette.white),
            lineStyle:
                charts.LineStyleSpec(color: charts.MaterialPalette.white),
          ),
        ),
      );

  List<charts.Series<VariationCount, String>> _getData() => [
        charts.Series<VariationCount, String>(
            id: 'Data',
            domainFn: (VariationCount variationCount, _) =>
                variationCount.intervalDescription,
            measureFn: (VariationCount variationCount, _) =>
                variationCount.count,
            data: countByInterval,
            labelAccessorFn: (VariationCount variationCount, _) =>
                '${variationCount.count}')
          // Set series to use the secondary measure axis.
          ..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId'),
      ];
}
