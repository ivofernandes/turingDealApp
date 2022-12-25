import 'dart:math';

import 'package:turing_deal/back_test_engine/core/utils/calculate_drawdown.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/base_strategy_result.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/strategy_drawdown.dart';
import 'package:turing_deal/market_data/core/indicators/sma.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class BuyAndHoldStrategy {
  /// Simulate a buy and hold strategy_result in the entire dataframe
  static BuyAndHoldStrategyResult buyAndHoldAnalysis(
      List<YahooFinanceCandleData> prices) {
    final BuyAndHoldStrategyResult strategy =
        BaseStrategyResult.createBuyAndHoldStrategyResult(prices);

    if (prices.isNotEmpty) {
      final double buyPrice = prices.first.open; // Buy in the open of the first day
      final double sellPrice = prices.last.close; // Sell on close of the last day
      strategy.endPrice = sellPrice;

      calculateStrategyMetrics(prices, buyPrice, sellPrice, strategy);
    }
    strategy.progress = 100;

    addIndicators(prices, strategy);

    strategy.logs['buyAndHoldEnded'] = DateTime.now();
    return strategy;
  }

  /// Add current price indicators to a strategy_result: SMA
  static void addIndicators(
      List<YahooFinanceCandleData> prices, BuyAndHoldStrategyResult strategy) {
    final List<int> periods = [20, 50, 200];
    periods.forEach((period) {
      final double movingAverage = SMA.atEnd(prices, period);
      strategy.movingAverages[period] = movingAverage;
    });
  }

  /// Calculate CAGR drawdown and MAR of an strategy_result
  static void calculateStrategyMetrics(List<YahooFinanceCandleData> prices,
      double buyPrice, double sellPrice, BuyAndHoldStrategyResult strategy) {
    // https://www.investopedia.com/terms/c/cagr.asp
    strategy.cagr =
        (pow(sellPrice / buyPrice, 1 / strategy.tradingYears) - 1) * 100;

    final StrategyDrawdown strategyDrawdown =
        CalculateDrawdown.calculateStrategyDrawdown(prices);

    strategy.maxDrawdown = strategyDrawdown.maxDrawdown;
    strategy.currentDrawdown = strategyDrawdown.currentDrawdown;

    // https://www.investopedia.com/terms/m/mar-ratio.asp
    strategy.mar = strategy.cagr / strategy.maxDrawdown * -1;
  }
}
