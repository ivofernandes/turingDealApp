import 'dart:collection';

import 'package:turing_deal/marketData/model/candle_price.dart';
import 'package:turing_deal/backTestEngine/core/utils/strategy_time.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/strategy_result.dart';

class BaseStrategyResult{
  // Percentage of strategyResult executed
  int progress = 0;

  DateTime? startDate;
  DateTime? endDate;
  double tradingYears = 0;

  double CAGR = 0;
  double drawdown = 0;
  double MAR = 0;

  LinkedHashMap<String, DateTime> logs = LinkedHashMap();

  @override
  String toString() => 'CAGR: $CAGR , drawdown: $drawdown, MAR: $MAR';

  static BuyAndHoldStrategyResult createBuyAndHoldStrategyResult(List<CandlePrice> prices){
    BuyAndHoldStrategyResult strategy = BuyAndHoldStrategyResult();
    addBaseDataToStrategy(strategy, prices);

    return strategy;
  }

  static StrategyResult createStrategyResult(List<CandlePrice> prices) {
    StrategyResult strategy = StrategyResult();
    addBaseDataToStrategy(strategy, prices);

    return strategy;
  }

  static void addBaseDataToStrategy(BaseStrategyResult strategy, List<CandlePrice> prices){
    strategy.logs['start'] = DateTime.now();

    if(prices.isNotEmpty) {
      StrategyTime.addTimeToStrategy(prices, strategy);
    }
  }

}
