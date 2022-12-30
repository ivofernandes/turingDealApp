import 'dart:collection';

import 'package:stock_market_data/stock_market_data.dart';
import 'package:turing_deal/back_test_engine/core/negotiation/signalizer/negotiation_signalizer.dart';
import 'package:turing_deal/back_test_engine/core/parser/parser_indicator.dart';
import 'package:turing_deal/back_test_engine/model/account/trading_account.dart';
import 'package:turing_deal/back_test_engine/model/shared/back_test_enums.dart';
import 'package:turing_deal/back_test_engine/model/strategy_config/strategy_config.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/strategy_result.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class StrategyRunner {
  final String ticker;
  final List<YahooFinanceCandleData> YahooFinanceCandleDatas;

  StrategyRunner(this.ticker, this.YahooFinanceCandleDatas);

  /// Simulate a buy and hold strategy_result in the entire dataframe
  StrategyResult run(StrategyConfig strategyConfig) {
    final StrategyResult strategy =
        StrategyResult.createStrategyResult(YahooFinanceCandleDatas);
    if (YahooFinanceCandleDatas.isNotEmpty) {
      //TODO execute the strategy_result
      print(strategyConfig.toString());

      // Prepare the candle prices to have the needed indicators
      final HashSet<String> indicators =
          ParserIndicator.extractBaseIndicators(strategyConfig.openningRules);
      CalculateIndicators.calculateIndicators(
          YahooFinanceCandleDatas, indicators.toList());

      executeStrategy(strategy, strategyConfig);
    }

    strategy.logs['strategyDone'] = DateTime.now();
    return strategy;
  }

  void executeStrategy(StrategyResult strategy, StrategyConfig strategyConfig) {
    // Create an account where the strategy will be executed
    final TradingAccount tradingAccount = TradingAccount();
    YahooFinanceCandleData? previousCandle;
    for (int i = 0; i < YahooFinanceCandleDatas.length; i++) {
      final YahooFinanceCandleData currentCandle = YahooFinanceCandleDatas[i];
      // Update the strategy stats and triggers (stops, targets, drawdown...)
      tradingAccount.updateAccount(currentCandle, previousCandle);

      openSignals(tradingAccount, currentCandle, strategyConfig);

      closeSignals(tradingAccount, currentCandle, strategyConfig);
      previousCandle = currentCandle;
    }

    tradingAccount.getTradingResults(strategy);
  }

  void openSignals(TradingAccount tradingAccount,
      YahooFinanceCandleData currentCandle, StrategyConfig strategyConfig) {
    // Perform the execution of rules for opening
    final Signal? openSignal =
        NegotiationSignalizer().openSignal(currentCandle, strategyConfig);

    // Perform trade
    if (openSignal == Signal.OPEN_LONG) {
      tradingAccount.openTrade(
          ticker, TradeType.LONG, currentCandle.date, currentCandle.close);
    }

    if (openSignal == Signal.OPEN_SHORT) {
      tradingAccount.openTrade(
          ticker, TradeType.SHORT, currentCandle.date, currentCandle.close);
    }
  }

  void closeSignals(TradingAccount tradingAccount,
      YahooFinanceCandleData currentCandle, StrategyConfig strategyConfig) {
    //TODO perform the execution of rules for closing

    final Signal? closeSignal =
        NegotiationSignalizer().closeSignal(currentCandle, strategyConfig);

    // Perform trade
    if (closeSignal == Signal.CLOSE_LONG) {
      tradingAccount.closeTrade(
          ticker, TradeType.LONG, currentCandle.date, currentCandle.close);
    }

    if (closeSignal == Signal.CLOSE_SHORT) {
      tradingAccount.closeTrade(
          ticker, TradeType.SHORT, currentCandle.date, currentCandle.close);
    }
  }
}
