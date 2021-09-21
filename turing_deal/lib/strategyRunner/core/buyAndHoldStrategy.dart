import 'dart:math';

import 'package:turing_deal/bigPicture/state/BigPictureStateProvider.dart';
import 'package:turing_deal/marketData/core/utils/cleanPrices.dart';
import 'package:turing_deal/marketData/model/candlePrices.dart';
import 'package:turing_deal/strategyRunner/core/indicators/movingAverage.dart';
import 'package:turing_deal/marketData/model/strategy.dart';

import 'utils/calculateDrawdown.dart';
import 'utils/strategyTime.dart';

class BuyAndHoldStrategy {

  /// Simulate a buy and hold strategy in the entire dataframe
  static StrategyResult buyAndHoldAnalysis(List<CandlePrices> prices) {

    StrategyResult strategy = StrategyResult();
    strategy.logs['start'] = DateTime.now();

    if(prices.isNotEmpty) {
      StrategyTime.addTimeToStrategy(prices, strategy);

      double buyPrice = prices.first.open; // Buy in the open of the first day
      double sellPrice = prices.last.close; // Sell on close of the last day
      strategy.endPrice = sellPrice;
      // https://www.investopedia.com/terms/c/cagr.asp
      strategy.CAGR =
          (pow(sellPrice / buyPrice, 1 / strategy.tradingYears) - 1) * 100;

      strategy.drawdown = CalculateDrawdown.maxDrawdown(prices);

      // https://www.investopedia.com/terms/m/mar-ratio.asp
      strategy.MAR = strategy.CAGR / strategy.drawdown * -1;

      strategy.progress = 100;
    }

    List<int> periods = [20, 50, 200];
    periods.forEach((period) {
      double movingAverage = CalculateMovingAverage.atEnd(prices, period);
      strategy.movingAverages[period] = movingAverage;
    });

    strategy.logs['buyAndHoldEnded'] = DateTime.now();
    return strategy;
  }

}