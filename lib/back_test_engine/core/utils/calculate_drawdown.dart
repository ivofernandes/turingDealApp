import 'dart:math';

import 'package:turing_deal/market_data/model/candle_price.dart';

class CalculateDrawdown{
  /// Calculate the drawdown of the buy and hold strategy_result
  static double maxDrawdown(List<CandlePrice> prices) {
    double maxDrawdown = 0;
    double currentDrawdown = 0;
    double allTimeHigh = 0;

    for(int i=0 ; i<prices.length ; i++){
      double adjhigh = prices[i].high;
      double? adjlow = prices[i].low;

      // Update drawdown
      if (adjhigh > allTimeHigh) {
        allTimeHigh = adjhigh;
      }
      else {
        currentDrawdown = (adjlow / allTimeHigh - 1) * 100;
      }

      maxDrawdown = min(maxDrawdown, currentDrawdown);
    }

    return maxDrawdown;
  }
}