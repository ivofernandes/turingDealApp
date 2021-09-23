import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/bigPicture/ui/explain/explainCagrUI.dart';
import 'package:turing_deal/bigPicture/ui/explain/explainDrawdownUI.dart';
import 'package:turing_deal/bigPicture/ui/explain/explainMarUI.dart';
import 'package:turing_deal/bigPicture/state/BigPictureStateProvider.dart';
import 'package:turing_deal/marketData/model/strategy.dart';
import 'package:turing_deal/shared/ui/UIUtils.dart';
import 'package:turing_deal/ticker/details/priveVariationChipUI.dart';


class StrategyResumeDetails extends StatelessWidget{
  final StrategyResult strategy;
  const StrategyResumeDetails(this.strategy);

  @override
  Widget build(BuildContext context) {
    BigPictureStateProvider bigPictureState =
      Provider.of<BigPictureStateProvider>(context, listen: false);

    String cagrText = 'CAGR: ' + strategy.CAGR.toStringAsFixed(2) + '%';
    String drawdownText = 'Drawdown: ' + strategy.drawdown.toStringAsFixed(2) + '%';
    String marText = 'MAR: ' + strategy.MAR.toStringAsFixed(2) ;

    double price_sma20 = (strategy.endPrice / strategy.movingAverages[20]! - 1) *100;
    double sma20sma50 = (strategy.movingAverages[20]! / strategy.movingAverages[50]! - 1) *100;
    double sma50sma200 = (strategy.movingAverages[50]! / strategy.movingAverages[200]! - 1) *100;

    return bigPictureState.isCompactView() ? Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PriceVariationChip(null, price_sma20),
        PriceVariationChip(null, sma20sma50),
        PriceVariationChip(null, sma50sma200)
      ],
    ) : Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                onTap: () => UIUtils.bottomSheet(ExplainCagr()),
                child: Text(cagrText)),
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
            PriceVariationChip('price/sma20', price_sma20),
            PriceVariationChip('sma20/sma50', sma20sma50),
            PriceVariationChip('sma50/sma200', sma50sma200)
          ],
        )
      ],
    );
  }

}