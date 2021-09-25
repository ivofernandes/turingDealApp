import 'dart:collection';

import 'package:turing_deal/marketData/model/candlePrice.dart';
import 'package:turing_deal/strategyEngine/core/buyAndHoldStrategy.dart';
import 'package:turing_deal/strategyEngine/core/utils/strategyTime.dart';
import 'package:turing_deal/strategyEngine/model/strategy/buyAndHoldStrategyResult.dart';

class BaseStrategyResult{
  // Percentage of strategy executed
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

  static void addBaseDataToStrategy(BaseStrategyResult strategy, List<CandlePrice> prices){
    strategy.logs['start'] = DateTime.now();

    if(prices.isNotEmpty) {
      StrategyTime.addTimeToStrategy(prices, strategy);
    }
  }

}
