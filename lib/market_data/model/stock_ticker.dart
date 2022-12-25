/// Represent an investment instrument
class StockTicker{

  String symbol;
  String? description;

  StockTicker(this.symbol,this.description);

  @override
  bool operator ==(Object other) => other is StockTicker && other.symbol == symbol;


  @override
  String toString() => 'symbol: $symbol > description: $description';

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;




}