import 'package:turing_deal/back_test_engine/core/negotiation/signalizer/negotiation_signalizer_checker.dart';
import 'package:turing_deal/back_test_engine/model/shared/back_test_enums.dart';
import 'package:turing_deal/back_test_engine/model/strategy_config/strategy_config.dart';
import 'package:turing_deal/back_test_engine/model/strategy_config/strategy_rule.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';

/// Class to create the signals
class NegotiationSignalizer {
  // Singleton
  static final NegotiationSignalizer _singleton =
      NegotiationSignalizer._internal();
  factory NegotiationSignalizer() {
    return _singleton;
  }
  NegotiationSignalizer._internal();

  Signal? openSignal(CandlePrice currentCandle, StrategyConfig strategyConfig) {
    for (StrategyConfigRules openRules in strategyConfig.openningRules) {
      for (StrategyConfigRule openRule in openRules.rules) {
        if (NegotiationSignalizerChecker()
            .checkCondition(openRule, currentCandle)) {
          if (strategyConfig.direction == TradeType.LONG) {
            return Signal.OPEN_LONG;
          } else if (strategyConfig.direction == TradeType.SHORT) {
            return Signal.OPEN_SHORT;
          }
        }
      }
    }

    return null;
  }

  Signal? closeSignal(
      CandlePrice currentCandle, StrategyConfig strategyConfig) {
    for (StrategyConfigRules closeRules in strategyConfig.closingRules) {
      for (StrategyConfigRule closeRule in closeRules.rules) {
        if (NegotiationSignalizerChecker()
            .checkCondition(closeRule, currentCandle)) {
          if (strategyConfig.direction == TradeType.LONG) {
            return Signal.CLOSE_LONG;
          } else if (strategyConfig.direction == TradeType.SHORT) {
            return Signal.CLOSE_SHORT;
          }
        }
      }
    }

    return null;
  }
}

enum Signal { OPEN_LONG, CLOSE_LONG, OPEN_SHORT, CLOSE_SHORT }
