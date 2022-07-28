import 'package:anchor_tabs/anchor_tabs.dart';
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
      List<Widget> tabs = [
        Text('Year stats'),
        Text('Daily variation'),
        Text('5d variation'),
        Text('20d variation'),
      ];
      List<Widget> body = [
        YearlyStatsWidget(),
        VariationProportion(
          delta: 1,
        ),
        VariationProportion(delta: 5),
        VariationProportion(delta: 20)
      ];

      return Container(
          margin: const EdgeInsets.all(10),
          child: AnchorTabPanel(tabs: tabs, body: body));
    } else {
      return SizedBox(
          width: 100,
          height: 200,
          child: Center(child: CircularProgressIndicator()));
    }
  }
}
