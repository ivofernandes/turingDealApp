import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ticker_details/src/state/ticker_state_provider.dart';
import 'package:ticker_details/src/ui/analysis/variation/variation_proportion_chart.dart';

class VariationProportion extends StatelessWidget {
  final int delta;

  const VariationProportion({
    required this.delta,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('VariationProportion.build(');
    final TickerStateProvider tickerState = Provider.of<TickerStateProvider>(context, listen: false);

    final List<YahooFinanceCandleData> data = tickerState.getCandlesData();

    bool needToCalculate = data.first.indicators.containsKey('var_$delta');

    final List<double> vars = Variations.extractList(data, delta);
    if (vars.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final stats = Stats.fromData(vars);
    final Stats statistics = stats.withPrecision(3);

    debugPrint('$statistics');

    final double upperLimit = (statistics.standardDeviation * 2).round().toDouble();
    final double lowerLimit = -upperLimit;
    final double step = (statistics.standardDeviation / 4 * 10).round() / 10;

    final List<VariationCount> countByInterval = Variations.countByInterval(lowerLimit, upperLimit, step, data, delta);

    return Column(
      children: [
        SizedBox(
          width: double.maxFinite,
          child: Center(
            child: Text(
              delta == 1 ? 'Variations of 1 day' : 'Variations of $delta days',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
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
          child: VariationProportionChart(
            countByInterval,
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
