import 'dart:math';

import 'package:turing_deal/back_test_engine/model/shared/back_test_enums.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/strategy_drawdown.dart';
import 'package:turing_deal/back_test_engine/model/trade/trade.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

@deprecated
class CalculateDrawdown {
  /// Calculate the drawdown of the buy and hold strategy_result
  static StrategyDrawdown calculateStrategyDrawdown(
      List<YahooFinanceCandleData> prices) {
    double maxDrawdown = 0;
    double currentDrawdown = 0;
    double allTimeHigh = 0;

    for (int i = 0; i < prices.length; i++) {
      final double adjhigh = prices[i].high;
      final double adjlow = prices[i].low;

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
      TradeOpen position, YahooFinanceCandleData currentCandle) {
    double currentDrawdown = 0;

    if (position.tradeType == TradeType.LONG) {
      currentDrawdown = calculatePercentageChange(
          position.tradeType, position.mostFavorablePrice, currentCandle.low);
    } else if (position.tradeType == TradeType.SHORT) {
      currentDrawdown = calculatePercentageChange(
          position.tradeType, position.mostFavorablePrice, currentCandle.high);
    }

    if (currentDrawdown < position.maxDrawdown) {
      position.maxDrawdown = currentDrawdown;
    }

    // Update the most favorable price after calculate the drawdown,
    // this should be after to avoid a situation
    // where the high is after the low but in the same daily bar
    if (position.tradeType == TradeType.LONG) {
      if (currentCandle.high > position.mostFavorablePrice) {
        position.mostFavorablePrice = currentCandle.high;
      }
    } else if (position.tradeType == TradeType.SHORT) {
      if (currentCandle.low < position.mostFavorablePrice) {
        position.mostFavorablePrice = currentCandle.low;
      }
    }
  }

  /// Calculate the percentage of change from the entry to the exit price
  static double calculatePercentageChange(
      TradeType type, double entry, double exit) {
    if (type == TradeType.LONG) {
      return (exit / entry - 1) * 100;
    } else if (type == TradeType.SHORT) {
      return (entry / exit - 1) * 100;
    } else {
      // If is not long neither short something is calculated here
      throw UnimplementedError();
    }
  }
}
