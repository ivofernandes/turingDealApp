import 'package:anchor_tabs/anchor_tabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/ticker/state/ticker_state_provider.dart';
import 'package:turing_deal/ticker/ui/analysis/variation/variation_proportion.dart';
import 'package:turing_deal/ticker/ui/analysis/variation/yearly_stats_widget.dart';

class TuringDealAnalysis extends StatelessWidget {
  const TuringDealAnalysis({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TickerStateProvider tickerState =
        Provider.of<TickerStateProvider>(context, listen: false);

    final List<int> variationsList = tickerState.getAvailableVariations();

    if (tickerState.isAnalysisComplete()) {
      final List<Widget> tabs = [
        const Text('Year stats'),
        const Text('Daily variation'),
        const Text('5d variation'),
        const Text('20d variation'),
      ];
      final List<Widget> body = [
        YearlyStatsWidget(),
        const VariationProportion(
          delta: 1,
        ),
        const VariationProportion(delta: 5),
        const VariationProportion(delta: 20)
      ];

      return Container(
          margin: const EdgeInsets.all(10),
          child: AnchorTabPanel(
            tabs: tabs,
            body: body,
          ));
    } else {
      return const SizedBox(
        width: 100,
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
