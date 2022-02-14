import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/market_data/model/stock_picker.dart';
import 'package:turing_deal/market_data/static/ticker_resolve.dart';

class StrategyResumeHeader extends StatelessWidget {
  final StockTicker ticker;
  final BuyAndHoldStrategyResult? strategy;
  final double width;

  const StrategyResumeHeader(this.ticker, this.strategy, this.width);

  @override
  Widget build(BuildContext context) {
    BigPictureStateProvider bigPictureState =
        Provider.of<BigPictureStateProvider>(context, listen: false);

    ThemeData theme = Theme.of(context);

    String ticketDescription = TickerResolve.getTickerDescription(ticker);

    return Column(children: [
      Row(
        mainAxisAlignment: bigPictureState.isCompactView()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: bigPictureState.isCompactView() ? width / 3 - 50 : width / 3,
            child: Text(ticker.symbol,
                style: theme.textTheme.headline6, overflow: TextOverflow.clip),
          ),
          bigPictureState.isCompactView()
              ? Container()
              : Text(ticketDescription, style: theme.textTheme.bodyText1)
        ],
      ),
      Divider(height: 5, color: theme.textTheme.bodyText1!.color),
      bigPictureState.isCompactView() ? Container() : SizedBox(height: 10),
      bigPictureState.isCompactView()
          ? Container()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(strategy!.tradingYears.ceil().toString() +
                    'y' +
                    (strategy!.tradingYears % 1 * 12).ceil().toString() +
                    'm'),
                strategy!.startDate != null && strategy!.endDate != null
                    ? Text('' +
                        DateFormat.yMd().format(strategy!.startDate!) +
                        ' to ' +
                        DateFormat.yMd().format(strategy!.endDate!))
                    : Container()
              ],
            ),
      bigPictureState.isCompactView() ? Container() : SizedBox(height: 10)
    ]);
  }
}
