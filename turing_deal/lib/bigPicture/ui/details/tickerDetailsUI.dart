import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/bigPicture/state/BigPictureStateProvider.dart';
import 'package:turing_deal/marketData/model/candlePrices.dart';
import 'package:turing_deal/marketData/model/stockTicker.dart';
import 'package:turing_deal/marketData/static/TickerResolve.dart';
import 'listPricesTextUI.dart';

class TickerDetails extends StatelessWidget {
  StockTicker ticker;

  TickerDetails(this.ticker);

  @override
  Widget build(BuildContext context) {

    BigPictureStateProvider bigPictureState =
      Provider.of<BigPictureStateProvider>(context, listen: false);

    return FutureBuilder<dynamic>(
        future: bigPictureState.getTickerData(this.ticker),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: Text(TickerResolve.getTickerDescription(this.ticker))
              ),
              body: snapshot.data == null
                  ? Center(child: CircularProgressIndicator())
                  : ListPricesText(snapshot.data as List<CandlePrices>)
        );
      }
    );
  }
}