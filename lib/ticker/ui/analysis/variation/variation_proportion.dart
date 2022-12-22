import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stats/stats.dart';
import 'package:turing_deal/market_data/core/indicators/variations.dart';
import 'package:turing_deal/market_data/model/variation/variation_count.dart';
import 'package:turing_deal/ticker/state/ticker_state_provider.dart';
import 'package:turing_deal/ticker/ui/analysis/variation/variation_proportion_chart.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class VariationProportion extends StatelessWidget {
  final int delta;

  VariationProportion({required this.delta});

  @override
  Widget build(BuildContext context) {
    TickerStateProvider tickerState =
        Provider.of<TickerStateProvider>(context, listen: false);

    List<YahooFinanceCandleData> data = tickerState.getCandlesData();
    List<double> vars = Variations.extractList(data, delta);
    if (vars.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    final stats = Stats.fromData(vars);
    Stats statistics = stats.withPrecision(3);

    print(statistics);

    double upperLimit = (statistics.standardDeviation * 2).round().toDouble();
    double lowerLimit = -upperLimit;
    double step = (statistics.standardDeviation / 4 * 10).round() / 10;

    List<VariationCount> countByInterval =
        Variations.countByInterval(lowerLimit, upperLimit, step, data, delta);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: double.maxFinite,
          child: Center(
            child: Text(
              delta == 1 ? 'Variations of 1 day' : 'Variations of $delta days',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Average: ${statistics.average}'),
              Text('Min: ${statistics.max}'),
              Text('Max: ${statistics.min}'),
              Text('Median: ${statistics.median}'),
              Text('Stddev: ${statistics.standardDeviation}'),
            ],
          ),
        ),
        SizedBox(
            height: 300,
            width: 300,
            child: VariationProportionChart(countByInterval)),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
