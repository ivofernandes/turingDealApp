class CleanPrices{

  /// Reverse the list from the first date to the end
  /// and calculate ajusted prices
  static List<dynamic> clean(List<dynamic> prices) {

    List<dynamic> cleanedPrices = [];

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
      double? proportion = prices[i]['adjclose'] / prices[i]['close'];
      cleanedPrices.add({
        'date': prices[i]['date'],
        'volume': prices[i]['volume'],
        'adjclose': prices[i]['adjclose'],
        'adjhigh': prices[i]['high'] * proportion,
        'adjlow': prices[i]['low'] * proportion
      });
    }

    return cleanedPrices;
  }
}