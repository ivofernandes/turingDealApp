import 'package:turing_deal/marketData/model/candlePrice.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/baseStrategyResult.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/buyAndHoldStrategyResult.dart';

class StrategyTime{

  /// Add start, end date and trading years to a strategyResult,
  /// note that the time comes in seconds since 1970
  static void addTimeToStrategy(List<CandlePrice> prices, BaseStrategyResult strategy) {
    // Get the start and end date, and the total trading years
    DateTime endDate = prices.last.date;
    DateTime startDate = prices.first.date;
    double tradingDays = endDate.difference(startDate).inDays.toDouble();
    double tradingYears = tradingDays / 365;
    strategy.startDate = startDate;
    strategy.endDate = endDate;
    strategy.tradingYears = tradingYears;
  }

  /// Check if a prices data stills valid
  /// This is done in json data
  static bool isUpToDate(List<dynamic> prices) {
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