import 'package:flutter/material.dart';
import 'package:turing_deal/marketData/model/stockTicker.dart';
import 'package:turing_deal/marketData/static/TickerResolve.dart';
import 'listPricesText.dart';
import '../../state/BigPictureStateProvider.dart';

class TickerDetails extends StatelessWidget {
  StockTicker ticker;
  BigPictureStateProvider bigPictureState;

  TickerDetails(this.ticker, this.bigPictureState);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: this.bigPictureState.getTickerData(this.ticker),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: Text(TickerResolve.getTickerDescription(this.ticker))
              ),
              body: snapshot.data == null
                  ? Center(child: CircularProgressIndicator())
                  : ListPricesText(snapshot.data as List<dynamic>?)
        );
      }
    );
  }
}