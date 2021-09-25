import 'dart:math';

import 'package:turing_deal/bigPicture/state/BigPictureStateProvider.dart';
import 'package:turing_deal/marketData/core/utils/cleanPrices.dart';
import 'package:turing_deal/marketData/model/candlePrice.dart';
import 'package:turing_deal/strategyEngine/core/indicators/movingAverage.dart';
import 'package:turing_deal/strategyEngine/model/strategy/baseStrategyResult.dart';
import 'package:turing_deal/strategyEngine/model/strategy/buyAndHoldStrategyResult.dart';
import 'utils/calculateDrawdown.dart';

class BuyAndHoldStrategy {

  /// Simulate a buy and hold strategy in the entire dataframe
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

  /// Add current price indicators to a strategy: SMA
  static void addIndicators(List<CandlePrice> prices, BuyAndHoldStrategyResult strategy) {
    List<int> periods = [20, 50, 200];
    periods.forEach((period) {
      double movingAverage = CalculateMovingAverage.atEnd(prices, period);
      strategy.movingAverages[period] = movingAverage;
    });
  }

  /// Calculate CAGR drawdown and MAR of an strategy
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