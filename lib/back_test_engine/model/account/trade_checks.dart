import 'package:turing_deal/back_test_engine/model/trade/trade.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class TradeChecks {
  static bool checkStop(
      TradeOpen position, YahooFinanceCandleData currentCandle) {
    //TODO check if trade hit a stop
    return false;
  }

  static bool checkLimit(
      TradeOpen position, YahooFinanceCandleData currentCandle) {
    //TODO check if trade hit a stop
    return false;
  }
}
