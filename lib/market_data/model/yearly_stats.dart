class YearlyStats {
  int year;
  double variation;
  double drawdown;

  YearlyStats(
      {required this.year, required this.variation, required this.drawdown});

  @override
  String toString() => 'BaseStats{year: $year, variation: $variation, drawdown: $drawdown}';
}
