import 'dart:collection';
import 'dart:math';

import 'package:turing_deal/backTestEngine/core/parser/parserIndicator.dart';
import 'package:turing_deal/marketData/core/utils/calculateIndicators.dart';
import 'package:turing_deal/backTestEngine/model/strategyConfig/strategyConfig.dart';
import 'package:turing_deal/bigPicture/state/BigPictureStateProvider.dart';
import 'package:turing_deal/marketData/core/utils/cleanPrices.dart';
import 'package:turing_deal/marketData/model/candlePrice.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/baseStrategyResult.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/buyAndHoldStrategyResult.dart';
import 'package:turing_deal/backTestEngine/model/strategyResult/strategyResult.dart';

import 'utils/calculateDrawdown.dart';
import 'utils/strategyTime.dart';

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

