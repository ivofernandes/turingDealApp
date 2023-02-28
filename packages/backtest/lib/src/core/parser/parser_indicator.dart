import 'dart:collection';

import 'package:backtest/src/model/strategy_config/strategy_config.dart';
import 'package:backtest/src/model/strategy_config/strategy_rule.dart';

class ParserIndicator {

  static HashSet<String> extractBaseIndicators(List<StrategyConfigRules> openningRules) {
    final HashSet<String> result = HashSet();

    openningRules.forEach((StrategyConfigRules configRules) {
      configRules.rules.forEach((StrategyConfigRule rule) {
        result.addAll(extractIndicatorsFromString(rule.indicator));
      });
    });

    return result;
  }

  static HashSet<String> extractIndicatorsFromString(String input) {
    final HashSet<String> result = HashSet();

    result.addAll(input.split('/'));

    return result;
  }
}