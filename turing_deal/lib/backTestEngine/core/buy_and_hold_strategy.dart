import 'dart:math';

import 'package:turing_deal/bigPicture/state/big_picture_state_provider.dart';
import 'package:turing_deal/marketData/core/indicators/sma.dart';
import 'package:turing_deal/marketData/core/utils/clean_prices.dart';
import 'package:turing_deal/marketData/model/candle_price.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/base_strategy_result.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/buy_and_hold_strategyResult.dart';
import 'utils/calculate_drawdown.dart';

class BuyAndHoldStrategy {

  /// Simulate a buy and hold strategyResult in the entire dataframe
  static BuyAndHoldStrategyResult buyAndHoldAnalysis(List<CandlePrice> prices) {
    BuyAndHoldStrategyResult strategy = BaseStrategyResult.createBuyAndHoldStrategyResult(prices);

    if(prices.isNotEmpty) {
      double buyPrice = prices.first.open; // Buy in the open of the first day
      double sellPrice = prices.last.close; // Sell on close of the last day
      strategy.endPrice = sellPrice;

      calculateStrategyMetrics(prices, buyPrice, sellPrice, strategy);

      strategy.progress = 100;
    }

    addIndicators(prices, strategy);

    strategy.logs['buyAndHoldEnded'] = DateTime.now();
    return strategy;
  }

  /// Add current price indicators to a strategyResult: SMA
  static void addIndicators(List<CandlePrice> prices, BuyAndHoldStrategyResult strategy) {
    List<int> periods = [20, 50, 200];
    periods.forEach((period) {
      double movingAverage = SMA.atEnd(prices, period);
      strategy.movingAverages[period] = movingAverage;
    });
  }

  /// Calculate CAGR drawdown and MAR of an strategyResult
  static void calculateStrategyMetrics(List<CandlePrice> prices, double buyPrice,
      double sellPrice, BuyAndHoldStrategyResult strategy) {

    // https://www.investopedia.com/terms/c/cagr.asp
    strategy.CAGR =
        (pow(sellPrice / buyPrice, 1 / strategy.tradingYears) - 1) * 100;

    strategy.drawdown = CalculateDrawdown.maxDrawdown(prices);

    // https://www.investopedia.com/terms/m/mar-ratio.asp
    strategy.MAR = strategy.CAGR / strategy.drawdown * -1;
  }

}