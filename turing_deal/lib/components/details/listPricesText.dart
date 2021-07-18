import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListPricesText extends StatelessWidget {
  final List<dynamic> data;

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
                  Expanded(child: Text('Date')),
                  Expanded(child: Text('Open')),
                  Expanded(child: Text('High')),
                  Expanded(child: Text('Low')),
                  Expanded(child: Text('Close')),
                ],
              );
            } else {
              return Row(
                children: [
                  TickerDetailsCell(DateFormat.yMd().format(
                      DateTime.fromMillisecondsSinceEpoch(
                          this.data[index]['date'] * 1000))),
                  TickerDetailsCell(this.data[index]['open'].toStringAsFixed(2)),
                  TickerDetailsCell(this.data[index]['high'].toStringAsFixed(2)),
                  TickerDetailsCell(this.data[index]['low'].toStringAsFixed(2)),
                  TickerDetailsCell(this.data[index]['close'].toStringAsFixed(2)),

                ],
              );
            }
          }),
    );
  }
}

class TickerDetailsCell extends StatelessWidget {
  final String text;

  const TickerDetailsCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text,
              style:
              Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 9)),
        ));
  }
}