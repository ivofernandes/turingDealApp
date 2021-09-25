import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/bigPicture/state/BigPictureStateProvider.dart';
import 'package:turing_deal/strategyEngine/model/strategy/buyAndHoldStrategyResult.dart';
import 'package:turing_deal/marketData/model/stockTicker.dart';
import 'package:turing_deal/marketData/static/TickerResolve.dart';

class StrategyResumeHeader extends StatelessWidget {
  final StockTicker ticker;
  final BuyAndHoldStrategyResult? strategy;

  const StrategyResumeHeader(this.ticker, this.strategy);

  @override
  Widget build(BuildContext context) {
    BigPictureStateProvider bigPictureState =
      Provider.of<BigPictureStateProvider>(context, listen: false);

    ThemeData theme = Theme.of(context);

    String ticketDescription = TickerResolve.getTickerDescription(ticker);

    return Column(children: [
      Row(
        mainAxisAlignment: bigPictureState.isCompactView() ? MainAxisAlignment.center :MainAxisAlignment.spaceBetween,
        children: [
          Text(ticker.symbol,
                style: theme.textTheme.headline6),
          bigPictureState.isCompactView() ? Container() : Text(
              ticketDescription,
              style: theme.textTheme.bodyText1)
        ],
      ),
      Divider(height: 5, color: theme.textTheme.bodyText1!.color),
      bigPictureState.isCompactView() ? Container() : SizedBox(height: 10),
      bigPictureState.isCompactView() ? Container() : Row(
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
      bigPictureState.isCompactView() ? Container() :SizedBox(height: 10)
    ]);
  }
}
