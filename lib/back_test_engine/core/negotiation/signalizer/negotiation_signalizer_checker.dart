import 'package:turing_deal/back_test_engine/model/strategy_config/strategy_rule.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';

/// Class to create the signals
class NegotiationSignalizerChecker {
  // Singleton
  static final NegotiationSignalizerChecker _singleton =
      NegotiationSignalizerChecker._internal();
  factory NegotiationSignalizerChecker() {
    return _singleton;
  }
  NegotiationSignalizerChecker._internal();

  bool checkCondition(StrategyConfigRule rule, CandlePrice candlePrice) {
    String indicator = rule.indicator;

    if (indicator.contains('/')) {
      return checkConditionDivision(rule, candlePrice, indicator);
    }

    return false;
  }

  bool checkConditionDivision(
      StrategyConfigRule rule, CandlePrice candlePrice, String indicator) {
    List<String> indicators = indicator.split('/');

    String indicatorA = indicators[0];
    String indicatorB = indicators[1];

    if (candlePrice.indicators.containsKey(indicatorA) &&
        candlePrice.indicators.containsKey(indicatorB)) {
      double indicatorAValue = candlePrice.indicators[indicatorA]!;
      double indicatorBValue = candlePrice.indicators[indicatorB]!;

      double ratio = indicatorAValue / indicatorBValue;

      if (rule.condition == ConditionRule.OVER) {
        return ratio > rule.referenceValue;
      } else if (rule.condition == ConditionRule.BELOW) {
        return ratio < rule.referenceValue;
      }
    }

    return false;
  }
}
