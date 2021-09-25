import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:turing_deal/marketData/core/utils/cleanPrices.dart';
import 'package:turing_deal/marketData/model/candlePrice.dart';
import 'package:turing_deal/strategyEngine/core/strategyRunner.dart';
import 'package:turing_deal/strategyEngine/model/strategy/strategyResult.dart';

void main() {
  test('Test a cross sma strategy on sp500', () async {
    String path = 'assets/marketData/yahooFinance/^GSPC.json';
    String content = await File(path).readAsString();
    List<dynamic> jsonObject = json.decode(content);

    List<CandlePrice> candlePrices = CleanPrices.clean(jsonObject);
    assert(candlePrices.isNotEmpty);

    String rules =
    '''
    open long: 
      SMA_50 > SMA_200
    close long:
      SMA_50 < SMA_200
    ''';
    StrategyRunner strategyRunner = StrategyRunner(candlePrices);
    StrategyResult result = strategyRunner.run(rules);

  });

  test('Test a cross sma strategy on sp500 with stops and target', () async {
    String path = 'assets/marketData/yahooFinance/^GSPC.json';
    String content = await File(path).readAsString();
    List<dynamic> jsonObject = json.decode(content);

    List<CandlePrice> candlePrices = CleanPrices.clean(jsonObject);
    assert(candlePrices.isNotEmpty);

    String rules =
    '''
    open long: 
      SMA_50 > SMA_200
    close long:
      SMA_50 < SMA_200
    stops:
      limit: 4%
      trailing: 6%
      trailingStep: 1%
    target: 10%
    ''';
    StrategyRunner strategyRunner = StrategyRunner(candlePrices);
    StrategyResult result = strategyRunner.run(rules);

  });
}
