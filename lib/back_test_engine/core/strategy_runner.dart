import 'dart:collection';

import 'package:turing_deal/back_test_engine/core/negotiation/signalizer/negotiation_signalizer.dart';
import 'package:turing_deal/back_test_engine/core/parser/parser_indicator.dart';
import 'package:turing_deal/back_test_engine/model/strategy_config/strategy_config.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/base_strategy_result.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/strategy_result.dart';
import 'package:turing_deal/market_data/core/utils/calculate_indicators.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';

class StrategyRunner {
  final List<CandlePrice> candlePrices;

  StrategyRunner(this.candlePrices) {}

  /// Simulate a buy and hold strategy_result in the entire dataframe
  StrategyResult run(StrategyConfig strategyConfig) {
    StrategyResult strategy =
        BaseStrategyResult.createStrategyResult(this.candlePrices);
    if (this.candlePrices.isNotEmpty) {
      //TODO execute the strategy_result
      print(strategyConfig.toString());

      // Prepare the candle prices to have the needed indicators
      HashSet<String> indicators =
          ParserIndicator.extractBaseIndicators(strategyConfig.openningRules);
      CalculateIndicators.calculateIndicators(
          candlePrices, indicators.toList());

      executeStrategy(strategy, strategyConfig);
    }

    strategy.logs['strategyDone'] = DateTime.now();
    return strategy;
  }

  void executeStrategy(StrategyResult strategy, StrategyConfig strategyConfig) {
    for (int i = 0; i < this.candlePrices.length; i++) {
      CandlePrice currentCandle = this.candlePrices[i];
      //TODO update the strategy stats and triggers (stops, targets, drawdown...)

      //TODO perform the execution of rules for opening
      Signal? openSignal =
          NegotiationSignalizer().openSignal(currentCandle, strategyConfig);
      //TODO perform the execution of rules for closing

      // Perform trade
      if (openSignal == Signal.OPEN_LONG) {
        print('Open long trade ${currentCandle.date} ');
      }

      if (openSignal == Signal.OPEN_SHORT) {
        print('Open short trade ${currentCandle.date} ');
      }
    }

    strategy.CAGR = 10;
    strategy.MAR = 1;
    strategy.drawdown = 30;
  }
}
