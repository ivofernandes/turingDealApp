class StrategyResult{

  // Percentage of strategy executed
  int progress = 0;

  DateTime? startDate;
  DateTime? endDate;
  double tradingYears = 0;

  double CAGR = 0;
  double drawdown = 0;
  double MAR = 0;

  double endPrice = 0;
  Map<int, double> movingAverages = {};

  @override
  String toString() => 'CAGR: $CAGR , drawdown: $drawdown, MAR: $MAR';
}