class StrategyResult{

  // Percentage of strategy executed
  int progress = 0;

  DateTime startDate;
  DateTime endDate;
  double tradingYears;

  double CAGR = 0;
  double drawdown = 0;
  double MAR = 0;

  @override
  String toString() => 'CAGR: $CAGR , drawdown: $drawdown, MAR: $MAR';
}