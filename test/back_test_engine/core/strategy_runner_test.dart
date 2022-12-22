import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:turing_deal/back_test_engine/core/strategy_runner.dart';
import 'package:turing_deal/back_test_engine/model/shared/back_test_enums.dart';
import 'package:turing_deal/back_test_engine/model/strategy_config/strategy_config.dart';
import 'package:turing_deal/back_test_engine/model/strategy_config/strategy_rule.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/strategy_result.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

void main() {
  StrategyConfig crossSMABaseStrategy = StrategyConfig(
      name: 'cross sm50/sma200',
      direction: TradeType.LONG,
      openningRules: [
        StrategyConfigRules(rules: [
          StrategyConfigRule(
              indicator: 'SMA_50/SMA_200',
              condition: ConditionRule.OVER,
              referenceValue: 1)
        ])
      ],
      closingRules: [
        StrategyConfigRules(rules: [
          StrategyConfigRule(
              indicator: 'SMA_50/SMA_200',
              condition: ConditionRule.BELOW,
              referenceValue: 1)
        ])
      ]);

  /// Tests a strategy like this one
  /// open long:
  /// SMA_50 > SMA_200
  /// close long:
  /// SMA_50 < SMA_200
  test('Test a cross sma strategy_result on sp500', () async {
    String path = 'test/test_data/yahoo_finance/^GSPC.json';
    String content = await File(path).readAsString();
    List<dynamic> jsonObject = json.decode(content);

    List<YahooFinanceCandleData> yahooFinanceCandleDatas =
        CleanPrices.clean(jsonObject);
    assert(yahooFinanceCandleDatas.isNotEmpty);

    StrategyRunner strategyRunner =
        StrategyRunner('^GSPC', yahooFinanceCandleDatas);
    StrategyResult result = strategyRunner.run(crossSMABaseStrategy);

    // Check if the strategy returned is valid
    assert(result.cagr > 0);
    assert(result.mar > 0);
    assert(result.tradingYears > 0);

    // Check if the indicators were added
    assert(yahooFinanceCandleDatas.last.indicators.containsKey('SMA_50'));
    assert(yahooFinanceCandleDatas.last.indicators.containsKey('SMA_200'));

    // TODO Check if made any trades
  });

  /// Test a strategy like this one
  ///   open long:
  ///     SMA_50 > SMA_200
  ///   close long:
  ///     SMA_50 < SMA_200
  ///   stops:
  ///     limit: 4%
  ///     trailing: 6%
  ///     trailingStep: 1%
  ///   target: 10%
  test('Test a cross sma strategy_result on sp500 with stops and target',
      () async {
    String path = 'test/test_data/yahoo_finance/^GSPC.json';
    String content = await File(path).readAsString();
    List<dynamic> jsonObject = json.decode(content);

    List<YahooFinanceCandleData> YahooFinanceCandleDatas =
        CleanPrices.clean(jsonObject);
    assert(YahooFinanceCandleDatas.isNotEmpty);

    StrategyRunner strategyRunner =
        StrategyRunner('^GSPC', YahooFinanceCandleDatas);
    StrategyResult result = strategyRunner.run(crossSMABaseStrategy);
  });
}
