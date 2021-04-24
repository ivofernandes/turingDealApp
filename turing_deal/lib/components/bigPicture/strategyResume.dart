import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:turing_deal/data/model/strategy.dart';
import 'package:turing_deal/data/model/ticker.dart';

class StrategyResume extends StatelessWidget {
  Ticker ticker;
  StrategyResult strategy;

  StrategyResume(this.ticker,this.strategy);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: strategy.loading == 100 ? Column(
          children: [
            Text(
                ticker.symbol + ' > ' + ticker.description,
                style: Theme.of(context).textTheme.headline6
            ),
            SizedBox(height:10),
            Align(
                alignment: Alignment.topRight,
                child: Text(
                    'Backtested from ' +
                    DateFormat.yMd().format(strategy.startDate) +
                    ' to ' + DateFormat.yMd().format(strategy.endDate)
                )
            ),
            SizedBox(height:10),

            Align(
                alignment: Alignment.topLeft,
                child: Text('CAGR: ' + strategy.CAGR.toStringAsFixed(2) + '%')),
            Align(
                alignment: Alignment.topLeft,
                child: Text('Dradown: ' + strategy.drawdown.toStringAsFixed(2) + '%')),
            Align(
                alignment: Alignment.topLeft,
                child: Text('MAR: ' + strategy.MAR.toStringAsFixed(2) ))
          ],
        ) :
        Column(
          children: [
            CircularProgressIndicator(
                value: strategy.loading / 100
            ),
            Text(strategy.loading.toString())
          ],
        ),
      ),
    );
  }
}
