

import 'package:turing_deal/market_data/model/candle_price.dart';

class SMA{

  static double atEnd(List<CandlePrice> prices, period) {
    double sum = 0;

    for(int i=prices.length-1 ; i>0 && i>=prices.length - period ; i--) {
      sum += prices[i].close;
    }

    return sum / period;
  }

  static void calculateSMA(List<CandlePrice> prices, int period) {
    if(prices.length < period){
      throw Exception('The prices list is just ${prices.length} and not enough to calculate a SMA_$period');
    }
    double sum = 0;
    double SMA = 0;

    // Calculate the first sum
    for(int j=period-1 ; j>=0 ; j--) {
      sum += prices[j].close;
    }
    // Calculate the SMA for the first calculable group of prices
    SMA = sum / period;
    prices[period -1].indicators['SMA_$period'] = SMA;

    // Roll over the rest of the dataframe
    for(int i=period ; i<prices.length ; i++){

      // subtract the element that with come out of the period
      sum -= prices[i- period].close;
      // Add the new element
      sum += prices[i].close;

      // Calculate the SMA
      SMA = sum / period;
      prices[i].indicators['SMA_$period'] = SMA;
    }
  }
}