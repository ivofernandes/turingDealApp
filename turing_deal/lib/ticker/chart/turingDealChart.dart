import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:turing_deal/marketData/model/candlePrice.dart';

class TuringDealChart extends StatelessWidget{
  final List<CandlePrice> data;
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