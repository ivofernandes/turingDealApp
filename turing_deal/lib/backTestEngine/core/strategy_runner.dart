import 'dart:collection';
import 'dart:math';

import 'package:turing_deal/backTestEngine/core/parser/parser_indicator.dart';
import 'package:turing_deal/marketData/core/utils/calculate_indicators.dart';
import 'package:turing_deal/backTestEngine/model/strategyConfig/strategy_config.dart';
import 'package:turing_deal/bigPicture/state/big_picture_state_provider.dart';
import 'package:turing_deal/marketData/core/utils/clean_prices.dart';
import 'package:turing_deal/marketData/model/candle_price.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/base_strategy_result.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/strategy_result.dart';

import 'utils/calculate_drawdown.dart';
import 'utils/strategy_time.dart';

class StrategyRunner {
  final List<CandlePrice> candlePrices;
  StrategyRunner(this.candlePrices){

  }

  /// Simulate a buy and hold strategyResult in the entire dataframe
  StrategyResult run(StrategyConfig strategyConfig) {
    StrategyResult strategy =
      BaseStrategyResult.createStrategyResult(this.candlePrices);
    if(this.candlePrices.isNotEmpty) {
      //TODO execute the strategyResult
      print(strategyConfig.toString());

      // Prepare the candle prices to have the needed indicators
      HashSet<String> indicators = ParserIndicator.extractBaseIndicators(strategyConfig.openningRules);
      CalculateIndicators.calculateIndicators(candlePrices, indicators.toList());

      executeStrategy(strategy);
    }

    strategy.logs['strategyDone'] = DateTime.now();
    return strategy;
  }

  void executeStrategy(StrategyResult strategy) {

    //TODO execute the strategy
    for(int i=0 ; i<this.candlePrices.length ; i++){
      //TODO update the strategy stats and triggers (stops, targets, drawdown...)

      //TODO perform the execution of rules for opening

      //TODO perform the execution of rules for closing

    }

    strategy.CAGR = 10;
    strategy.MAR = 1;
    strategy.drawdown = 30;
  }

}

