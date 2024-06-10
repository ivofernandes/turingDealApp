import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class ListPricesText extends StatelessWidget {
  final List<YahooFinanceCandleData> data;

  const ListPricesText(this.data);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Row(
                children: const [
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
                  TickerDetailsCell(
                      DateFormat.yMd().format(data[index].date)),
                  TickerDetailsCell(data[index].open.toStringAsFixed(2)),
                  TickerDetailsCell(data[index].high.toStringAsFixed(2)),
                  TickerDetailsCell(data[index].low.toStringAsFixed(2)),
                  TickerDetailsCell(data[index].close.toStringAsFixed(2)),
                ],
              );
            }
          }),
    );
}

class TickerDetailsCell extends StatelessWidget {
  final String? text;

  const TickerDetailsCell(this.text);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8),
      child: FittedBox(
        child: SelectableText(text!,
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 9)),
      ),
    ));
}
