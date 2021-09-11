import 'dart:math';

import 'package:turing_deal/bigPicture/state/BigPictureStateProvider.dart';
import 'package:turing_deal/marketData/core/strategy/calculations/calculateMovingAverages.dart';
import 'package:turing_deal/marketData/model/strategy.dart';

import 'calculations/calculateDrawdown.dart';
import 'utils/cleanPrices.dart';
import 'utils/strategyTime.dart';

class BuyAndHoldStrategy {
  /// Simulate a buy and hold strategy
  static StrategyResult buyAndHoldAnalysis(
      List<dynamic> prices,
      BigPictureStateProvider bigPictureStateProvider) {

    StrategyResult strategy = StrategyResult();

    prices = CleanPrices.clean(prices);

    if(prices.isNotEmpty) {
      StrategyTime.addTimeToStrategy(prices, strategy);

      double buyPrice = double.parse(prices.first['adjclose'].toString());
      double sellPrice = double.parse(prices.last['adjclose'].toString());

      // https://www.investopedia.com/terms/c/cagr.asp
      strategy.CAGR =
          (pow(sellPrice / buyPrice, 1 / strategy.tradingYears!) - 1) * 100;

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

    return strategy;
  }

}