import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/bigPicture/state/BigPictureStateProvider.dart';
import 'package:turing_deal/marketData/model/candlePrice.dart';
import 'package:turing_deal/marketData/model/stockTicker.dart';
import 'package:turing_deal/marketData/static/TickerResolve.dart';
import 'package:turing_deal/ticker/chart/turingDealChart.dart';

import 'details/listPricesTextUI.dart';

class TickerScreen extends StatelessWidget {
  StockTicker ticker;

  TickerScreen(this.ticker);

  @override
  Widget build(BuildContext context) {

    BigPictureStateProvider bigPictureState =
      Provider.of<BigPictureStateProvider>(context, listen: false);

    return FutureBuilder<dynamic>(
        future: bigPictureState.getTickerData(this.ticker),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  title: Text(TickerResolve.getTickerDescription(this.ticker))
                ),
                body: snapshot.data == null
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                      padding: const EdgeInsets.all(20.0),
                      child: TuringDealChart(snapshot.data as List<CandlePrice>),
                   //ListPricesText((snapshot.data as List<CandlePrice>).reversed.toList())
                    )
        ),
          );
      }
    );
  }
}