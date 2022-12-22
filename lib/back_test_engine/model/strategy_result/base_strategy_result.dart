import 'dart:collection';

import 'package:turing_deal/back_test_engine/model/strategy_result/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/strategy_result.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class BaseStrategyResult {
  // Percentage of strategy_result executed
  int progress = 0;

  DateTime? startDate;
  DateTime? endDate;
  double tradingYears = 0;

  double cagr = 0;
  double maxDrawdown = 0;
  double mar = 0;

  double currentDrawdown = 0;

  LinkedHashMap<String, DateTime> logs = LinkedHashMap();

  int tradesNum = 0;

  @override
  String toString() => 'CAGR: $cagr , drawdown: $maxDrawdown, MAR: $mar';

  static BuyAndHoldStrategyResult createBuyAndHoldStrategyResult(
      List<YahooFinanceCandleData> prices) {
    BuyAndHoldStrategyResult strategy = BuyAndHoldStrategyResult();
    addBaseDataToStrategy(strategy, prices);

    return strategy;
  }

  static StrategyResult createStrategyResult(
      List<YahooFinanceCandleData> prices) {
    StrategyResult strategy = StrategyResult();
    addBaseDataToStrategy(strategy, prices);

    return strategy;
  }

  static void addBaseDataToStrategy(
      BaseStrategyResult strategy, List<YahooFinanceCandleData> prices) {
    strategy.logs['start'] = DateTime.now();

    if (prices.isNotEmpty) {
      addTimeToStrategy(prices, strategy);
    }
  }

  /// Add start, end date and trading years to a strategy_result,
  /// note that the time comes in seconds since 1970
  static void addTimeToStrategy(
      List<YahooFinanceCandleData> prices, BaseStrategyResult strategy) {
    // Get the start and end date, and the total trading years
    DateTime endDate = prices.last.date;
    DateTime startDate = prices.first.date;
    double tradingDays = endDate.difference(startDate).inDays.toDouble();
    double tradingYears = tradingDays / 365;
    strategy.startDate = startDate;
    strategy.endDate = endDate;
    strategy.tradingYears = tradingYears;
  }
}
