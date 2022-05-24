import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/ticker/state/ticker_state_provider.dart';
import 'package:turing_deal/ticker/ui/analysis/variation/variation_proportion.dart';
import 'package:turing_deal/ticker/ui/analysis/variation/yearly_stats_widget.dart';

class TuringDealAnalysis extends StatelessWidget {
  const TuringDealAnalysis();

  @override
  Widget build(BuildContext context) {
    TickerStateProvider tickerState =
        Provider.of<TickerStateProvider>(context, listen: false);

    List<int> variationsList = tickerState.getAvailableVariations();

    if (tickerState.isAnalysisComplete()) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            YearlyStatsWidget(),
            VariationProportion(
              delta: 1,
            ),
            VariationProportion(delta: 5),
            VariationProportion(delta: 20)
          ],
        ),
      );
    } else {
      return SizedBox(
          width: 100,
          height: 200,
          child: Center(child: CircularProgressIndicator()));
    }
  }
}
