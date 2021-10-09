import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/bigPicture/ui/explain/explain_cagr_ui.dart';
import 'package:turing_deal/bigPicture/ui/explain/explain_drawdown_ui.dart';
import 'package:turing_deal/bigPicture/ui/explain/explain_mar_ui.dart';
import 'package:turing_deal/bigPicture/state/big_picture_state_provider.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/shared/ui/UIUtils.dart';
import 'package:turing_deal/ticker/details/prive_variation_chip_ui.dart';


class StrategyResumeDetails extends StatelessWidget{
  final BuyAndHoldStrategyResult strategy;
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