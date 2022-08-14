import 'dart:math';

import 'package:turing_deal/back_test_engine/model/shared/back_test_enums.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/strategy_drawdown.dart';
import 'package:turing_deal/back_test_engine/model/trade/trade.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';

class CalculateDrawdown {
  /// Calculate the drawdown of the buy and hold strategy_result
  static StrategyDrawdown calculateStrategyDrawdown(List<CandlePrice> prices) {
    double maxDrawdown = 0;
    double currentDrawdown = 0;
    double allTimeHigh = 0;

    for (int i = 0; i < prices.length; i++) {
      double adjhigh = prices[i].high;
      double adjlow = prices[i].low;

      // Update drawdown
      if (adjhigh > allTimeHigh) {
        allTimeHigh = adjhigh;
      } else {
        currentDrawdown = (adjlow / allTimeHigh - 1) * 100;
      }

      maxDrawdown = min(maxDrawdown, currentDrawdown);
    }

    return StrategyDrawdown(
        currentDrawdown: currentDrawdown, maxDrawdown: maxDrawdown);
  }

  static void updateTradeDrawdown(
      TradeOpen position, CandlePrice currentCandle) {
    if (position.tradeType == TradeType.LONG) {}
  }

  static double calculatePercentageChange(
      TradeType type, double entry, double exit) {
    if (type == TradeType.LONG) {
      return (exit / entry - 1) * 100;
    }
    // Short
    else {
      return (entry / exit - 1) * 100;
    }
  }
}
