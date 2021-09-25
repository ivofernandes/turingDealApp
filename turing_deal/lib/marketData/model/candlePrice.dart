class CandlePrice{
  final DateTime date;
  final double volume;

  final double open;
  final double close;
  final double high;
  final double low;

  final Map<String, double> indicators = const {};

  const CandlePrice({
    required this.date,
    required this.volume,

    required this.open,
    required this.close,
    required this.high,
    required this.low,
  });
}