import 'package:flutter/material.dart';
import 'package:turing_deal/components/details/listPricesText.dart';
import 'package:turing_deal/data/model/ticker.dart';
import 'package:turing_deal/data/state/BigPictureStateProvider.dart';

class TickerDetails extends StatelessWidget {
  Ticker ticker;
  BigPictureStateProvider bigPictureState;

  TickerDetails(this.ticker, this.bigPictureState);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: this.bigPictureState.getTickerData(this.ticker),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: Text(this.ticker.description),
              ),
              body: snapshot.data == null
                  ? CircularProgressIndicator()
                  : ListPricesText(snapshot.data as List<dynamic>));
        });
  }
}