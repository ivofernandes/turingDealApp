import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/bigPicture/state/BigPictureStateProvider.dart';
import 'package:turing_deal/marketData/model/candlePrices.dart';
import 'package:turing_deal/marketData/model/stockTicker.dart';
import 'package:turing_deal/marketData/static/TickerResolve.dart';

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
          return Scaffold(
              appBar: AppBar(
                title: Text(TickerResolve.getTickerDescription(this.ticker))
              ),
              body: snapshot.data == null
                  ? Center(child: CircularProgressIndicator())
                  : TuringDealChart(snapshot.data as List<CandlePrices>) // ListPricesText(snapshot.data as List<CandlePrices>)
        );
      }
    );
  }
}

class TuringDealChart extends StatelessWidget{
  final List<CandlePrices> data;
  const TuringDealChart(this.data);

  @override
  Widget build(BuildContext context) {
    List<CandleData> _rawData = [
    // timestamp, open, high, low, close, volume
    ];
    data.forEach((element) {
      CandleData candle = CandleData(
          timestamp: element.date.millisecondsSinceEpoch,
          open: element.open, close: element.close, volume: element.volume,
          low: element.low, high: element.high);
      _rawData.add(candle);
    });

    return InteractiveChart(
        /** Only [candles] is required */
        candles: _rawData
    );
  }
}