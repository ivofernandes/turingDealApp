/// Represent an investment instrument
class Ticker{

  String symbol;
  String? description;

  Ticker(this.symbol,this.description);

  bool operator ==(Object other) => other is Ticker && other.symbol == symbol;

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => 'symbol: $symbol > description: $description';

}