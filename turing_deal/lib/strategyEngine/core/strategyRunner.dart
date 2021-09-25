import 'dart:math';

import 'package:turing_deal/bigPicture/state/BigPictureStateProvider.dart';
import 'package:turing_deal/marketData/core/utils/cleanPrices.dart';
import 'package:turing_deal/marketData/model/candlePrice.dart';
import 'package:turing_deal/strategyEngine/core/indicators/movingAverage.dart';
import 'package:turing_deal/strategyEngine/model/strategy/baseStrategyResult.dart';
import 'package:turing_deal/strategyEngine/model/strategy/buyAndHoldStrategyResult.dart';
import 'package:turing_deal/strategyEngine/model/strategy/strategyResult.dart';

import 'utils/calculateDrawdown.dart';
import 'utils/strategyTime.dart';

class StrategyRunner {
  final List<CandlePrice> candlePrices;
  StrategyRunner(this.candlePrices){

  }

  /// Simulate a buy and hold strategy in the entire dataframe
  StrategyResult run(String rules) {
    StrategyResult strategy =
      BaseStrategyResult.createBuyAndHoldStrategyResult(this.candlePrices) as StrategyResult;
    if(this.candlePrices.isNotEmpty) {
      //TODO execute the strategy
      print(rules);

      strategy.progress = 100;
    }

    strategy.logs['strategyDone'] = DateTime.now();
    return strategy;
  }

}

