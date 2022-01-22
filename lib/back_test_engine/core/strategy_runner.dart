import 'dart:collection';

import 'package:turing_deal/back_test_engine/core/negotiation/signalizer/negotiation_signalizer.dart';
import 'package:turing_deal/back_test_engine/core/parser/parser_indicator.dart';
import 'package:turing_deal/back_test_engine/model/account/trading_account.dart';
import 'package:turing_deal/back_test_engine/model/shared/back_test_enums.dart';
import 'package:turing_deal/back_test_engine/model/strategy_config/strategy_config.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/base_strategy_result.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/strategy_result.dart';
import 'package:turing_deal/market_data/core/utils/calculate_indicators.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';

class StrategyRunner {
  final String ticker;
  final List<CandlePrice> candlePrices;

  StrategyRunner(this.ticker, this.candlePrices) {}

  /// Simulate a buy and hold strategy_result in the entire dataframe
  StrategyResult run(StrategyConfig strategyConfig) {
    StrategyResult strategy =
        BaseStrategyResult.createStrategyResult(this.candlePrices);
    if (this.candlePrices.isNotEmpty) {
      //TODO execute the strategy_result
      print(strategyConfig.toString());

      // Prepare the candle prices to have the needed indicators
      HashSet<String> indicators =
          ParserIndicator.extractBaseIndicators(strategyConfig.openningRules);
      CalculateIndicators.calculateIndicators(
          candlePrices, indicators.toList());

      executeStrategy(strategy, strategyConfig);
    }

    strategy.logs['strategyDone'] = DateTime.now();
    return strategy;
  }

  void executeStrategy(StrategyResult strategy, StrategyConfig strategyConfig) {
    // Create an account where the strategy will be executed
    TradingAccount tradingAccount = TradingAccount();

    for (int i = 0; i < this.candlePrices.length; i++) {
      CandlePrice currentCandle = this.candlePrices[i];
      // Update the strategy stats and triggers (stops, targets, drawdown...)
      tradingAccount.updateAccount(currentCandle);

      openSignals(tradingAccount, currentCandle, strategyConfig);

      closeSignals(tradingAccount, currentCandle, strategyConfig);
    }

    tradingAccount.getTradingResults(strategy);
  }

  void openSignals(TradingAccount tradingAccount, CandlePrice currentCandle,
      StrategyConfig strategyConfig) {
    // Perform the execution of rules for opening
    Signal? openSignal =
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

  void closeSignals(TradingAccount tradingAccount, CandlePrice currentCandle,
      StrategyConfig strategyConfig) {
    //TODO perform the execution of rules for closing

    Signal? closeSignal =
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
