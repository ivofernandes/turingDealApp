/// Represent an investment instrument
class StockTicker{

  String symbol;
  String? description;

  StockTicker(this.symbol,this.description);

  bool operator ==(Object other) => other is StockTicker && other.symbol == symbol;

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => 'symbol: $symbol > description: $description';

}