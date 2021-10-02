import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:turing_deal/marketData/model/candlePrice.dart';

class ListPricesText extends StatelessWidget {
  final List<CandlePrice> data;

  const ListPricesText(this.data);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: this.data.length +1 ,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Row(
                children: [
                  Expanded(child: Text('Date', textAlign: TextAlign.center)),
                  Expanded(child: Text('Open', textAlign: TextAlign.center)),
                  Expanded(child: Text('High', textAlign: TextAlign.center)),
                  Expanded(child: Text('Low', textAlign: TextAlign.center)),
                  Expanded(child: Text('Close', textAlign: TextAlign.center)),
                ],
              );
            } else {
              return Row(
                children: [
                  TickerDetailsCell(DateFormat.yMd().format(this.data[index].date)),
                  TickerDetailsCell(this.data[index].open.toStringAsFixed(2)),
                  TickerDetailsCell(this.data[index].high.toStringAsFixed(2)),
                  TickerDetailsCell(this.data[index].low.toStringAsFixed(2)),
                  TickerDetailsCell(this.data[index].close.toStringAsFixed(2)),

                ],
              );
            }
          }),
    );
  }
}

class TickerDetailsCell extends StatelessWidget {
  final String? text;

  const TickerDetailsCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(
            child: SelectableText(text!,
                style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 9)),
          ),
        ));
  }
}