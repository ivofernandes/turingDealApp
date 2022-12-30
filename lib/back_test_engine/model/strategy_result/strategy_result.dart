import 'package:stock_market_data/stock_market_data.dart';
import 'package:yahoo_finance_data_reader/src/daily/model/yahoo_finance_candle_data.dart';

class StrategyResult extends BaseStrategyResult {
  final List<YahooFinanceCandleData> yahooFinanceCandles;

  StrategyResult({
    required this.yahooFinanceCandles,
  });

  factory StrategyResult.createStrategyResult(
          List<YahooFinanceCandleData> yahooFinanceCandleDatas) =>
      StrategyResult(yahooFinanceCandles: yahooFinanceCandleDatas);
}
