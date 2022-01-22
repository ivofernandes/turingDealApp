import 'dart:collection';

import 'package:turing_deal/back_test_engine/model/account/portfolio.dart';
import 'package:turing_deal/back_test_engine/model/shared/back_test_enums.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/strategy_result.dart';
import 'package:turing_deal/back_test_engine/model/trade/trade.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';

/// Class that represents the account in a broker
class TradingAccount with Portfolio {
  static const double INITIAL_BALANCE = 10000;

  double balance = INITIAL_BALANCE;
  LinkedHashMap<DateTime, double> balanceHistory = LinkedHashMap();

  List<TradeHistory> tradesHistory = [];

  void openTrade(
      String ticker, TradeType tradeType, DateTime date, double price) {
    if (!isTradeOpen(ticker, tradeType)) {
      print('Open $tradeType trade $date @price $price');
      addToPortfolio(ticker, tradeType, date, price);
    }
  }

  void closeTrade(
      String ticker, TradeType tradeType, DateTime date, double close) {
    if (isTradeOpen(ticker, tradeType)) {
      print('Close $tradeType trade $date @price $close');
      removeFromPortfolio(ticker, tradeType);
    }
  }

  void updateAccount(CandlePrice currentCandle) {
    updatePortfolio(currentCandle);
  }

  void getTradingResults(StrategyResult strategy) {
    // TODO Calculate the metrics from trades list

    strategy.CAGR = 10;
    strategy.MAR = 1;
    strategy.drawdown = 30;
  }
}
