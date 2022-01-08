import 'package:turing_deal/back_test_engine/model/shared/back_test_enums.dart';
import 'package:turing_deal/back_test_engine/model/strategy_config/strategy_rule.dart';

/// This class is a structured representation of a trading strategy like this one:
///    open long:
///       RSI_3 < 20
///     close long:
///       RSI_3 > 80
class StrategyConfig {
  // The name of the strategy
  String name;

  // If the strategy is long or short
  TradeType direction;

  // Target revenue that the strategy tries to make in each trade
  double? target;

  // Stop loss limit
  double? stopLimit;

  // Trailing stop
  double? trailingStopLimit;
  double? trailingStopStep;

  // Lists with rules for open or close trades, for example,
  // if you want to open trades on: RSI_3 < 10 or RSI_5 < 20
  // these should be two different opening rules
  // Rules for opening trades
  List<StrategyConfigRules> openningRules;

  // Rules for close trades
  List<StrategyConfigRules> closingRules;

  StrategyConfig(
      {required this.name,
      required this.direction,
      this.target,
      this.stopLimit,
      this.trailingStopLimit,
      this.trailingStopStep,
      required this.openningRules,
      required this.closingRules});

  @override
  String toString() {
    return 'StrategyConfig{name: $name, direction: $direction, target: $target, stopLimit: $stopLimit, trailingStopLimit: $trailingStopLimit, trailingStopStep: $trailingStopStep, openningRules: $openningRules, closingRules: $closingRules}';
  }
}

class StrategyConfigRules {
  List<StrategyConfigRule> rules;

  StrategyConfigRules({required this.rules});
}
