import 'package:turing_deal/data/model/strategy.dart';
import 'package:turing_deal/data/state/BigPictureStateProvider.dart';
import 'dart:math';

class BuyAndHoldStrategy{

  /// Simulate a buy and hold strategy
  static Strategy buyAndHoldAnalysis(Map<String,dynamic> historicalPrices, BigPictureStateProvider bigPictureStateProvider){

    List prices = historicalPrices['prices'];

    Strategy strategy = Strategy();
    strategy.valid = false;

    if(prices.isNotEmpty) {
      addTimetToStrategy(prices, strategy);

      double buyPrice = prices.last['adjclose'];
      double sellPrice = prices.first['adjclose'];

      // https://www.investopedia.com/terms/c/cagr.asp
      strategy.CAGR = (pow(sellPrice / buyPrice, 1 / strategy.tradingYears) - 1) * 100;

      strategy.drawdown = calculateDrawdown(prices);

      // https://www.investopedia.com/terms/m/mar-ratio.asp
      strategy.MAR = strategy.CAGR / strategy.drawdown * -1;

      strategy.valid = true;
    }

    return strategy;
  }

  /// Add start, end date and trading years to a strategy,
  /// note that the time comes in seconds since 1970
  static void addTimetToStrategy(List prices, Strategy strategy) {

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
  static double calculateDrawdown(List prices) {
    double maxDrawdown = 0;
    double currentDrawdown = 0;
    double allTimeHigh = 0;

    for(int i=prices.length-1 ; i>0 ; i--){
      // Get date values
      double proportion = prices[i]['adjclose'] / prices[i]['close'];
      double adjustedHigh = prices[i]['high'] * proportion;
      double adjustedLow = prices[i]['low'] * proportion;

      // Update drawdown
      if(adjustedHigh > allTimeHigh) {
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