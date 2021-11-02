import 'dart:collection';

import 'package:turing_deal/back_test_engine/model/strategy_config/strategy_config.dart';
import 'package:turing_deal/back_test_engine/model/strategy_config/strategy_rule.dart';

class ParserIndicator{

  static HashSet<String> extractBaseIndicators(List<StrategyConfigRules> openningRules) {
    HashSet<String> result = HashSet();

    openningRules.forEach((StrategyConfigRules configRules) {
      configRules.rules.forEach((StrategyConfigRule rule) {
        result.addAll(extractIndicatorsFromString(rule.indicator));
      });
    });

    return result;
  }

 static HashSet<String> extractIndicatorsFromString(String input){
   HashSet<String> result = HashSet();

   result.addAll(input.split('/'));

   return result;
 }
}