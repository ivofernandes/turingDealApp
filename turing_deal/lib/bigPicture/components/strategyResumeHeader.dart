import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:turing_deal/marketData/model/strategy.dart';
import 'package:turing_deal/marketData/model/ticker.dart';
import '../state/BigPictureStateProvider.dart';

class StrategyResumeHeader extends StatelessWidget {
  final Ticker ticker;
  final StrategyResult? strategy;
  final BigPictureStateProvider bigPictureState;

  const StrategyResumeHeader(this.ticker, this.strategy, this.bigPictureState);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String ticketDescription = getTickerDescription(ticker);

    return Column(children: [
      ListTile(
        leading: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 150),
          child: Text(ticker.symbol,
              style: theme.textTheme.headline6),
        ),
        title: Text(ticketDescription,
            style: theme.textTheme.bodyText1),
      ),
      Divider(height: 5, color: theme.textTheme.bodyText1!.color),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          strategy!.tradingYears != null
              ? Text(strategy!.tradingYears!.ceil().toString() +
                  'y' +
                  (strategy!.tradingYears! % 1 * 12).ceil().toString() +
                  'm')
              : Container(),
          strategy!.startDate != null && strategy!.endDate != null
              ? Text('' +
                  DateFormat.yMd().format(strategy!.startDate!) +
                  ' to ' +
                  DateFormat.yMd().format(strategy!.endDate!))
              : Container()
        ],
      ),
      SizedBox(height: 10)
    ]);
  }

  String getTickerDescription(Ticker ticker) {
    if(ticker.description != null){
      return ticker.description!;
    }
    else{
      //TODO get from TickersList
      return '';
    }
  }
}
