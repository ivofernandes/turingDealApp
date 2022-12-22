import 'package:turing_deal/market_data/core/indicators/sma.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class CalculateIndicators {
  ///
  static void calculateIndicators(
      List<YahooFinanceCandleData> prices, List<String> indicators) {
    // Calculate the indicators one by one
    indicators.forEach((indicator) {
      Map<String, int> indicatorValidated = validateIndicator(indicator);
      if (indicatorValidated.isNotEmpty) {
        String indicatorType = indicatorValidated.keys.first;
        int indicatorPeriod = indicatorValidated[indicatorType]!;

        _calculateIndicator(prices, indicatorType, indicatorPeriod);
      }
    });
  }

  static void _calculateIndicator(
      List<YahooFinanceCandleData> prices, String indicator, int period) {
    switch (indicator) {
      case 'SMA':
        SMA.calculateSMA(prices, period);
        break;
      case 'EMA':
        print('EMA not implemented');
    }
  }

  static Map<String, int> validateIndicator(String indicator) {
    List<String> indicatorParts = indicator.split('_');

    if (indicatorParts.length == 2) {
      try {
        var period = int.parse(indicatorParts[1]);

        return {indicatorParts[0]: period};
      } catch (e) {
        print(indicator + ' is not an indicator!');
      }
    }

    return {};
  }
}
