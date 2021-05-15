import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:turing_deal/data/model/strategy.dart';
import 'package:turing_deal/data/model/ticker.dart';
import 'package:turing_deal/data/state/BigPictureStateProvider.dart';

class StrategyResumeHeader extends StatelessWidget {
  final Ticker ticker;
  final StrategyResult strategy;
  final BigPictureStateProvider bigPictureState;

  const StrategyResumeHeader(this.ticker, this.strategy, this.bigPictureState);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    int years = strategy.tradingYears.ceil();
    int months = (strategy.tradingYears % 1 * 12).ceil();

    return Column(children: [
      ListTile(
        leading: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 150),
          child: Text(ticker.symbol,
              style: theme.textTheme.headline6),
        ),
        title: Text(ticker.description,
            style: theme.textTheme.bodyText1),
      ),
      Divider(height: 5, color: theme.textTheme.bodyText1.color),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(years.toString() +
              'y' +
              months.toString() + 'm' ),
          Text('Backtested from ' +
              DateFormat.yMd().format(strategy.startDate) +
              ' to ' +
              DateFormat.yMd().format(strategy.endDate))
        ],
      ),
      SizedBox(height: 10)
    ]);
  }
}
