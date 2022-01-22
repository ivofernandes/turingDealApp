import 'package:turing_deal/back_test_engine/model/shared/back_test_enums.dart';
import 'package:turing_deal/back_test_engine/model/trade/trade.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';

/// Here we manage the current trades
mixin Portfolio {
  List<TradeOpen> portfolio = [];

  /// Check the portfolio to know if a trade is already open
  bool isTradeOpen(String ticker, TradeType tradeType) {
    for (TradeOpen portfolioItem in portfolio) {
      if (portfolioItem.ticker == ticker &&
          portfolioItem.tradeType == tradeType) {
        return true;
      }
    }

    return false;
  }

  void addToPortfolio(
      String ticker, TradeType tradeType, DateTime date, double price) {
    portfolio.add(TradeOpen(
        trade: Trade(
            ticker: ticker,
            tradeType: tradeType,
            openDate: date,
            openPrice: price)));
  }

  void removeFromPortfolio(String ticker, TradeType tradeType) {
    for (TradeOpen portfolioItem in portfolio) {
      if (portfolioItem.ticker == ticker &&
          portfolioItem.tradeType == tradeType) {
        portfolio.remove(portfolioItem);
        break;
      }
    }
  }

  void updatePortfolio(CandlePrice currentCandle) {
    //TODO check if any stop order was triggered

    //TODO check if any limit order was triggered
  }
}
