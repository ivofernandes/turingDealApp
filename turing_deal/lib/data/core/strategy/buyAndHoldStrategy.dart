import 'dart:math';

import 'package:turing_deal/data/model/strategy.dart';
import 'package:turing_deal/data/state/BigPictureStateProvider.dart';

class BuyAndHoldStrategy {
  /// Simulate a buy and hold strategy
  static StrategyResult buyAndHoldAnalysis(
      Map<String, dynamic> historicalPrices,
      BigPictureStateProvider bigPictureStateProvider) {
    List<dynamic> prices = historicalPrices['prices'];

    StrategyResult strategy = StrategyResult();

    if(prices.isNotEmpty) {
      addTimeToStrategy(prices, strategy);

      double buyPrice = double.parse(prices.last['adjclose'].toString());
      double sellPrice = double.parse(prices.first['adjclose'].toString());

      // https://www.investopedia.com/terms/c/cagr.asp
      strategy.CAGR =
          (pow(sellPrice / buyPrice, 1 / strategy.tradingYears) - 1) * 100;

      strategy.drawdown = calculateDrawdown(prices);

      // https://www.investopedia.com/terms/m/mar-ratio.asp
      strategy.MAR = strategy.CAGR / strategy.drawdown * -1;

      strategy.progress = 100;
    }

    return strategy;
  }

  /// Add start, end date and trading years to a strategy,
  /// note that the time comes in seconds since 1970
  static void addTimeToStrategy(List<dynamic> prices, StrategyResult strategy) {
    // Get the start and end date, and the total trading years
    DateTime endDate = DateTime.fromMillisecondsSinceEpoch(prices.first['date']*1000);
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(prices.last['date']*1000);
    double tradingDays = (prices.first['date'] - prices.last['date']) / 60 / 60 / 24;

    double tradingYears = tradingDays / 365;
    strategy.startDate = startDate;
    strategy.endDate = endDate;
    strategy.tradingYears = tradingYears;
  }

  /// Calculate the drawdown of the buy and hold strategy
  static double calculateDrawdown(List<dynamic> prices) {
    double maxDrawdown = 0;
    double currentDrawdown = 0;
    double allTimeHigh = 0;

    for(int i=prices.length-1 ; i>0 ; i--){
      if(prices[i].keys.contains('type')
          && (prices[i]['type'] == 'DIVIDEND' || prices[i]['type'] == 'SPLIT')){
        // Ignore dividends in the middle, all the juice is on adjclose
        continue;
      }

      if(prices[i]['adjclose'] == null){
        continue;
      }

      // Get date values
      double proportion = prices[i]['adjclose'] / prices[i]['close'];
      double adjustedHigh = prices[i]['high'] * proportion;
      double adjustedLow = prices[i]['low'] * proportion;

      // Update drawdown
      if (adjustedHigh > allTimeHigh) {
        allTimeHigh = adjustedHigh;
      }
      else {
        currentDrawdown = (adjustedLow / allTimeHigh - 1) * 100;
      }

      maxDrawdown = min(maxDrawdown, currentDrawdown);
    }

    return maxDrawdown;
  }

}