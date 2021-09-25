import 'package:turing_deal/marketData/model/candlePrice.dart';

class CalculateMovingAverage{

  static double atEnd(List<CandlePrice> prices, period) {
    double sum = 0;

    for(int i=prices.length-1 ; i>0 && i>=prices.length - period ; i--) {
      sum += prices[i].close;
    }

    return sum / period;
  }
}