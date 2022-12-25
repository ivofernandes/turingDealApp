import 'dart:math';

import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class CalculateStrategyMetrics {
  static double calculateCAGR(List<YahooFinanceCandleData> candles) {
    final double tradingDays =
        candles.last.date.difference(candles.first.date).inDays.toDouble();
    final double tradingYears = tradingDays / 365;

    final double cagr =
        (pow(candles.last.close / candles.first.close, 1 / tradingYears) - 1) *
            100;
    return cagr;
  }
}
