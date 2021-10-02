class StrategyConfigRule {
  String indicator;
  ConditionRule condition;
  double referenceValue;

  StrategyConfigRule({
    required this.indicator,
    required this.condition,
    required this.referenceValue
  });

}

enum ConditionRule {
  OVER,
  BELOW
}