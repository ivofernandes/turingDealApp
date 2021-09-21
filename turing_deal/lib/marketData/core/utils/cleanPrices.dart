import 'package:turing_deal/marketData/model/candlePrices.dart';

class CleanPrices{

  /// Reverse the list from the first date to the end
  /// and calculate ajusted prices
  static List<CandlePrices> clean(List<dynamic> prices) {

    List<CandlePrices> cleanedPrices = [];

    for(int i=prices.length-1 ; i>0 ; i--){
      if(prices[i].keys.contains('type')
          && (prices[i]['type'] == 'DIVIDEND' || prices[i]['type'] == 'SPLIT')){
        // Ignore dividends in the middle, all the juice is on adjclose
        continue;
      }

      if(prices[i]['adjclose'] == null){
        continue;
      }

      // Get date values
      double proportion = prices[i]['adjclose'] / prices[i]['close'];
      cleanedPrices.add(
        CandlePrices(
          date: DateTime.fromMillisecondsSinceEpoch(prices[i]['date']*1000),
          volume: prices[i]['volume'].toDouble(),
          open: prices[i]['open'].toDouble() * proportion,
          close: prices[i]['adjclose'].toDouble(),
          high: prices[i]['high'].toDouble() * proportion,
          low: prices[i]['low'].toDouble() * proportion
        )
      );
    }

    return cleanedPrices;
  }
}