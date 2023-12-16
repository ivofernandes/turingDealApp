import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:td_ui/td_ui.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/big_picture/ui/explain/explain_cagr_ui.dart';
import 'package:turing_deal/big_picture/ui/explain/explain_drawdown_ui.dart';
import 'package:turing_deal/big_picture/ui/explain/explain_mar_ui.dart';
import 'package:turing_deal/big_picture/ui/resume/strategy_resume_item.dart';
import 'package:turing_deal/big_picture/ui/resume/strategy_resume_ui.dart';

class StrategyResumeDetails extends StatelessWidget {
  final BuyAndHoldStrategyResult strategy;

  const StrategyResumeDetails(this.strategy);

  @override
  Widget build(BuildContext context) {
    final BigPictureStateProvider bigPictureState = Provider.of<BigPictureStateProvider>(context, listen: false);

    final double pricesma20 = (strategy.endPrice / strategy.movingAverages[20]! - 1) * 100;
    final double sma20sma50 = (strategy.movingAverages[20]! / strategy.movingAverages[50]! - 1) * 100;
    final double sma50sma200 = (strategy.movingAverages[50]! / strategy.movingAverages[200]! - 1) * 100;

    String prefixVar20 = '';
    String prefixVar50 = '';
    String prefixVar200 = '';

    if (!bigPictureState.isCompactView()) {
      prefixVar20 = 'price/sma20';
      prefixVar50 = 'sma20/sma50';
      prefixVar200 = 'sma50/sma200';
    }

    final priceVarChip20 = PriceVariationChip(
      prefix: prefixVar20,
      value: pricesma20,
    );
    final priceVarChip50 = PriceVariationChip(
      prefix: prefixVar50,
      value: sma20sma50,
    );
    final priceVarChip200 = PriceVariationChip(
      prefix: prefixVar200,
      value: sma50sma200,
    );

    return bigPictureState.isCompactView()
        ? Column(
            children: [
              priceVarChip20,
              priceVarChip50,
              priceVarChip200,
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: StrategyResume.resumeLeftColumn,
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
                        value: '${strategy.currentDrawdown.toStringAsFixed(2)}%',
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
                  priceVarChip20,
                  priceVarChip50,
                  priceVarChip200,
                ],
              )
            ],
          );
  }
}
