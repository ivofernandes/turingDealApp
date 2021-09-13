import 'package:turing_deal/marketData/model/strategy.dart';

class StrategyTime{

  /// Add start, end date and trading years to a strategy,
  /// note that the time comes in seconds since 1970
  static void addTimeToStrategy(List<dynamic> prices, StrategyResult strategy) {
    // Get the start and end date, and the total trading years
    DateTime endDate = DateTime.fromMillisecondsSinceEpoch(prices.last['date']*1000);
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(prices.first['date']*1000);
    double tradingDays = (prices.last['date'] - prices.first['date']) / 60 / 60 / 24;

    double tradingYears = tradingDays / 365;
    strategy.startDate = startDate;
    strategy.endDate = endDate;
    strategy.tradingYears = tradingYears;
  }

  /// Check if a prices data stills valid
  static bool isUpToDate(List prices) {
    DateTime now = DateTime.now();

    // Go to the last working day
    while(now.weekday > 5){
      now = now.subtract(Duration(hours: 4));
    }

    DateTime lastPrice = DateTime.fromMillisecondsSinceEpoch(prices.first['date'] * 1000);
    
    Duration difference = now.difference(lastPrice);
    bool isUpToDate = difference.inHours < 12;

    return isUpToDate;
  }
}