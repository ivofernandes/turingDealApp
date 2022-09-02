import 'package:turing_deal/back_test_engine/core/utils/calculate_drawdown.dart';
import 'package:turing_deal/back_test_engine/model/account/trade_checks.dart';
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

  TradeOpen? removeFromPortfolio(String ticker, TradeType tradeType) {
    for (TradeOpen portfolioItem in portfolio) {
      if (portfolioItem.ticker == ticker &&
          portfolioItem.tradeType == tradeType) {
        portfolio.remove(portfolioItem);
        return portfolioItem;
      }
    }

    return null;
  }

  /// update portfolio open positions
  void updatePortfolio(CandlePrice currentCandle) {
    for (TradeOpen position in portfolio) {
      // Check if any stop order was triggered
      bool stopped = TradeChecks.checkStop(position, currentCandle);
      if (stopped) continue;

      // Check if any limit order was triggered
      bool limited = TradeChecks.checkLimit(position, currentCandle);
      if (limited) continue;

      // Check how the drawdown changed
      CalculateDrawdown.updateTradeDrawdown(position, currentCandle);
    }
  }
}
