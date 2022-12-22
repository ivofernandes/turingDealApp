import 'dart:collection';

import 'package:turing_deal/back_test_engine/model/account/portfolio.dart';
import 'package:turing_deal/back_test_engine/model/shared/back_test_enums.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/strategy_result.dart';
import 'package:turing_deal/back_test_engine/model/trade/trade.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

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
      TradeOpen? tradeOpen = removeFromPortfolio(ticker, tradeType);

      if (tradeOpen != null) {
        tradesHistory.add(TradeHistory(
            trade: tradeOpen,
            closeDate: date,
            closePrice: close,
            maxDrawdown: tradeOpen.maxDrawdown));
      }
    }
  }

  void updateAccount(YahooFinanceCandleData currentCandle,
      YahooFinanceCandleData? previousCandle) {
    // If nothing changed
    if (previousCandle == null || portfolio.isEmpty) {
      DateTime date = currentCandle.date;

      balanceHistory[date] = balance;
    }

    updatePortfolio(currentCandle);
  }

  void getTradingResults(StrategyResult strategy) {
    // TODO Calculate the metrics from trades list
    strategy.tradesNum = tradesHistory.length;
    strategy.cagr = 10;
    strategy.mar = 1;
    strategy.maxDrawdown = 30;
  }
}
