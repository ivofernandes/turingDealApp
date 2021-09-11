import 'package:flutter/material.dart';
import 'package:turing_deal/bigPicture/explain/explainCagr.dart';
import 'package:turing_deal/bigPicture/explain/explainDrawdown.dart';
import 'package:turing_deal/bigPicture/explain/explainMAR.dart';
import 'package:turing_deal/marketData/model/strategy.dart';
import 'package:turing_deal/shared/components/UIUtils.dart';

class StrategyResumeDetails extends StatelessWidget{
  final StrategyResult strategy;
  const StrategyResumeDetails(this.strategy);

  @override
  Widget build(BuildContext context) {
    String cagrText = 'CAGR: ' + strategy.CAGR.toStringAsFixed(2) + '%';
    String drawdownText = 'Drawdown: ' + strategy.CAGR.toStringAsFixed(2) + '%';
    String marText = 'MAR: ' + strategy.MAR.toStringAsFixed(2) ;

    double sma20sma50 = (strategy.movingAverages[20]! / strategy.movingAverages[50]! - 1) *100;
    String sma20sma50Text = 'sma20/sma50: ' + sma20sma50.toStringAsFixed(2) + '%';

    double sma20sma200 = (strategy.movingAverages[20]! / strategy.movingAverages[200]! - 1) *100;
    String sma20sma200Text = 'sma20/sma200: ' + sma20sma200.toStringAsFixed(2) + '%';

    double sma50sma200 = (strategy.movingAverages[50]! / strategy.movingAverages[200]! - 1) *100;
    String sma50sma200Text = 'sma50/sma200: ' + sma50sma200.toStringAsFixed(2) + '%';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                onTap: () => UIUtils.bottomSheet(ExplainCagr()),
                child: Text(cagrText, textAlign: TextAlign.left,)),
            InkWell(
                onTap: () => UIUtils.bottomSheet(ExplainDrawdown()),
                child: Text(drawdownText)),
            InkWell(
                onTap: () => UIUtils.bottomSheet(ExplainMAR()),
                child: Text(marText))
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(sma20sma50Text),
            Text(sma20sma200Text),
            Text(sma50sma200Text)
          ],
        )
      ],
    );
  }
}