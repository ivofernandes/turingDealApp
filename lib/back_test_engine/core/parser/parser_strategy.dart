import 'package:turing_deal/back_test_engine/model/shared/back_test_enums.dart';
import 'package:turing_deal/back_test_engine/model/strategy_config/strategy_config.dart';
import 'package:turing_deal/back_test_engine/model/strategy_config/strategy_rule.dart';

/// Parser that will be able to compile a string into an strategy
class ParserStrategy{

  /// TODO this function should be able compile a strategy based on a string
  /// to a actual StrategyConfig object
  /// open long:
  /// SMA_50 > SMA_200
  /// close long:
  /// SMA_50 < SMA_200
  static StrategyConfig parse(String strategy){
    print('!! TODO parse strategy!!');

    final StrategyConfig crossSMABaseStrategy = StrategyConfig(
        name: 'cross sm50/sma200',
        direction: TradeType.LONG,
        openningRules: [
          StrategyConfigRules(rules: [
            StrategyConfigRule(
                indicator: 'SMA_50/SMA_200',
                condition: ConditionRule.OVER,
                referenceValue: 0)
          ])
        ],
        closingRules: [
          StrategyConfigRules(rules: [
            StrategyConfigRule(
                indicator: 'SMA_50/SMA_200',
                condition: ConditionRule.BELOW,
                referenceValue: 0)
          ])
        ]);
    return crossSMABaseStrategy;
  }
}