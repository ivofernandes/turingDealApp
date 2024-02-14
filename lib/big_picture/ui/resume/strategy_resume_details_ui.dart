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
      stops: {-2: Theme.of(context).colorScheme.error, 0.0: Colors.grey, 2: Theme.of(context).colorScheme.primary},
    );
    final priceVarChip50 = PriceVariationChip(
      prefix: prefixVar50,
      value: sma20sma50,
      stops: {-5: Theme.of(context).colorScheme.error, 0.0: Colors.grey, 5: Theme.of(context).colorScheme.primary},
    );
    final priceVarChip200 = PriceVariationChip(
      prefix: prefixVar200,
      value: sma50sma200,
      stops: {-10: Theme.of(context).colorScheme.error, 0.0: Colors.grey, 10: Theme.of(context).colorScheme.primary},
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
                      text: '${strategy.cagr.toStringAsFixed(2)}%',
                      value: strategy.cagr,
                      stops: {
                        0: Theme.of(context).colorScheme.error,
                        10: Theme.of(context).colorScheme.primary,
                      },
                      onTap: () => UIUtils.bottomSheet(
                        ExplainCagr(),
                        contextParam: context,
                      ),
                    ),
                    StrategyResumeItem(
                      title: '% to top',
                      text: '${strategy.currentDrawdown.toStringAsFixed(2)}%',
                      value: strategy.currentDrawdown,
                      stops: {
                        0: Theme.of(context).colorScheme.error,
                        35: Theme.of(context).colorScheme.primary,
                      },
                      onTap: () => UIUtils.bottomSheet(
                        ExplainDrawdown(),
                        contextParam: context,
                      ),
                    ),
                    StrategyResumeItem(
                      title: 'Drawdown',
                      text: '${strategy.maxDrawdown.toStringAsFixed(2)}%',
                      value: strategy.maxDrawdown,
                      stops: {
                        10: Theme.of(context).colorScheme.primary,
                        70: Theme.of(context).colorScheme.error,
                      },
                      onTap: () => UIUtils.bottomSheet(
                        ExplainDrawdown(),
                        contextParam: context,
                      ),
                    ),
                    StrategyResumeItem(
                      title: 'MAR',
                      text: strategy.mar.toStringAsFixed(2),
                      value: strategy.mar,
                      stops: {
                        0.1: Theme.of(context).colorScheme.error,
                        0.4: Theme.of(context).colorScheme.primary,
                      },
                      onTap: () => UIUtils.bottomSheet(
                        ExplainMAR(),
                        contextParam: context,
                      ),
                    ),
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
