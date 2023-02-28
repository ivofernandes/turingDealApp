import 'package:backtest/src/model/shared/back_test_enums.dart';

/// Represents a trade
class Trade {
  // Ticker of the trade
  final String ticker;

  // If the trade is long or short
  final TradeType tradeType;

  // Time at the opening of the trade
  final DateTime openDate;

  // Price of the asset at the opening of the trade
  final double openPrice;

  Trade({required this.ticker, required this.tradeType, required this.openDate, required this.openPrice});

  @override
  String toString() => 'Trade{ticker: $ticker, tradeType: $tradeType, openDate: $openDate, openPrice: $openPrice}';
}

class TradeOpen extends Trade {
  // currentDrawdown
  double maxDrawdown;

  // Trade all time high in case of a long trade,
  // and all time low in case of the short trade
  double mostFavorablePrice;

  TradeOpen({required Trade trade, this.maxDrawdown = 0, this.mostFavorablePrice = 0})
      : super(ticker: trade.ticker, tradeType: trade.tradeType, openDate: trade.openDate, openPrice: trade.openPrice) {
    mostFavorablePrice = trade.openPrice;
  }
}

class TradeHistory extends Trade {
  // Time at the close of the trade
  final DateTime closeDate;

  // Price of the asset at the close of the trade
  final double closePrice;

  // Max drawdown
  double maxDrawdown = 0;

  TradeHistory({required Trade trade, required this.closeDate, required this.closePrice, required this.maxDrawdown})
      : super(ticker: trade.ticker, tradeType: trade.tradeType, openDate: trade.openDate, openPrice: trade.openPrice);

  @override
  String toString() => 'TradeHistory{ticker: $ticker, tradeType: $tradeType, '
      'openDate: $openDate, openPrice: $openPrice, '
      'closeDate: $closeDate, closePrice: $closePrice}';
}
