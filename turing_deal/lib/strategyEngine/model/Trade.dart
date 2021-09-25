/// Represents a trade
class Trade {
  // If the trade is long or short
  final TradeType tradeType;

  // Time at the opening of the trade
  final DateTime openDate;

  // Price of the asset at the opening of the trade
  final double openPrice;



  /*
  'stopLossLimit': stopLossLimit,
  'drawdown': 0,
  'maxResult':0
*/
  Trade({
    required this.tradeType,
    required this.openDate,
    required this.openPrice
  });
}

class TradeOpen extends Trade{

  // currentDrawdown
  double currentMaxDrawdown = 0;

  // current result

  TradeOpen({
    required Trade trade
  }): super(
    tradeType: trade.tradeType,
      openDate: trade.openDate,
      openPrice: trade.openPrice
  );
}

class TradeHistory extends Trade{

  // Time at the close of the trade
  final DateTime closeDate;

  // Price of the asset at the close of the trade
  final double closePrice;

  // Max drawdown
  double maxDrawdown = 0;

  TradeHistory({
    required Trade trade,
    required this.closeDate,
    required this.closePrice,
    required this.maxDrawdown
  }): super(
    tradeType: trade.tradeType,
    openDate: trade.openDate,
    openPrice: trade.openPrice
  );
}

enum TradeType{LONG, SHORT}