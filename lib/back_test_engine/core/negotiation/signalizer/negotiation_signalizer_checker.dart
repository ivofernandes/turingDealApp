import 'package:turing_deal/back_test_engine/model/strategy_config/strategy_rule.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

/// Class to create the signals
class NegotiationSignalizerChecker {
  // Singleton
  static final NegotiationSignalizerChecker _singleton =
      NegotiationSignalizerChecker._internal();
  factory NegotiationSignalizerChecker() {
    return _singleton;
  }
  NegotiationSignalizerChecker._internal();

  bool checkCondition(
      StrategyConfigRule rule, YahooFinanceCandleData YahooFinanceCandleData) {
    String indicator = rule.indicator;

    if (indicator.contains('/')) {
      return checkConditionDivision(rule, YahooFinanceCandleData, indicator);
    }

    return false;
  }

  bool checkConditionDivision(StrategyConfigRule rule,
      YahooFinanceCandleData YahooFinanceCandleData, String indicator) {
    List<String> indicators = indicator.split('/');

    String indicatorA = indicators[0];
    String indicatorB = indicators[1];

    if (YahooFinanceCandleData.indicators.containsKey(indicatorA) &&
        YahooFinanceCandleData.indicators.containsKey(indicatorB)) {
      double indicatorAValue = YahooFinanceCandleData.indicators[indicatorA]!;
      double indicatorBValue = YahooFinanceCandleData.indicators[indicatorB]!;

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
