import 'dart:collection';

import 'package:turing_deal/back_test_engine/core/utils/strategy_time.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/strategy_result.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';

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
      List<CandlePrice> prices) {
    BuyAndHoldStrategyResult strategy = BuyAndHoldStrategyResult();
    addBaseDataToStrategy(strategy, prices);

    return strategy;
  }

  static StrategyResult createStrategyResult(List<CandlePrice> prices) {
    StrategyResult strategy = StrategyResult();
    addBaseDataToStrategy(strategy, prices);

    return strategy;
  }

  static void addBaseDataToStrategy(
      BaseStrategyResult strategy, List<CandlePrice> prices) {
    strategy.logs['start'] = DateTime.now();

    if (prices.isNotEmpty) {
      StrategyTime.addTimeToStrategy(prices, strategy);
    }
  }
}
