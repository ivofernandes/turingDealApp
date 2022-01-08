class StrategyConfigRule {
  String indicator;
  ConditionRule condition;
  double referenceValue;

  StrategyConfigRule(
      {required this.indicator,
      required this.condition,
      required this.referenceValue});

  @override
  String toString() {
    return '$indicator $condition $referenceValue';
  }
}

enum ConditionRule { OVER, BELOW }
