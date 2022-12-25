import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/big_picture/ui/explain/explain_cagr_ui.dart';
import 'package:turing_deal/big_picture/ui/explain/explain_drawdown_ui.dart';
import 'package:turing_deal/big_picture/ui/explain/explain_mar_ui.dart';
import 'package:turing_deal/big_picture/ui/resume/strategy_resume_item.dart';
import 'package:turing_deal/big_picture/ui/resume/strategy_resume_ui.dart';
import 'package:turing_deal/shared/ui/UIUtils.dart';
import 'package:turing_deal/ticker/ui/details/price_variation_chip_ui.dart';

class StrategyResumeDetails extends StatelessWidget {
  final BuyAndHoldStrategyResult strategy;
  const StrategyResumeDetails(this.strategy);

  @override
  Widget build(BuildContext context) {
    final BigPictureStateProvider bigPictureState =
        Provider.of<BigPictureStateProvider>(context, listen: false);

    final double pricesma20 =
        (strategy.endPrice / strategy.movingAverages[20]! - 1) * 100;
    final double sma20sma50 =
        (strategy.movingAverages[20]! / strategy.movingAverages[50]! - 1) * 100;
    final double sma50sma200 =
        (strategy.movingAverages[50]! / strategy.movingAverages[200]! - 1) *
            100;

    return bigPictureState.isCompactView()
        ? Container(
            child: Column(
              children: [
                PriceVariationChip(null, pricesma20),
                PriceVariationChip(null, sma20sma50),
                PriceVariationChip(null, sma50sma200)
              ],
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: StrategyResume.RESUME_LEFT_COLUMN,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StrategyResumeItem(
                      title: 'CAGR',
                      value: '${strategy.cagr.toStringAsFixed(2)}%',
                      onTap: () => UIUtils.bottomSheet(
                        ExplainCagr(),
                        contextParam: context,
                      ),
                    ),
                    StrategyResumeItem(
                        title: '% from top',
                        value:
                            '${strategy.currentDrawdown.toStringAsFixed(2)}%',
                        onTap: () => UIUtils.bottomSheet(
                              ExplainDrawdown(),
                              contextParam: context,
                            )),
                    StrategyResumeItem(
                        title: 'Drawdown',
                        value: '${strategy.maxDrawdown.toStringAsFixed(2)}%',
                        onTap: () => UIUtils.bottomSheet(
                              ExplainDrawdown(),
                              contextParam: context,
                            )),
                    StrategyResumeItem(
                        title: 'MAR',
                        value: strategy.mar.toStringAsFixed(2),
                        onTap: () => UIUtils.bottomSheet(
                              ExplainMAR(),
                              contextParam: context,
                            )),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PriceVariationChip('price/sma20', pricesma20),
                  PriceVariationChip('sma20/sma50', sma20sma50),
                  PriceVariationChip('sma50/sma200', sma50sma200)
                ],
              )
            ],
          );
  }
}
