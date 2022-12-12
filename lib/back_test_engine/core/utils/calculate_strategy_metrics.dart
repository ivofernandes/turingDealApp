import 'dart:math';

import 'package:turing_deal/market_data/model/candle_price.dart';

class CalculateStrategyMetrics {
  static double calculateCAGR(List<CandlePrice> candles) {
    double tradingDays =
        candles.last.date.difference(candles.first.date).inDays.toDouble();
    double tradingYears = tradingDays / 365;

    double cagr =
        (pow(candles.last.close / candles.first.close, 1 / tradingYears) - 1) *
            100;
    return cagr;
  }
}
