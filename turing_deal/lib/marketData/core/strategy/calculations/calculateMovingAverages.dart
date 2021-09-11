class CalculateMovingAverage{

  static double atEnd(List<dynamic> prices, period) {
    double sum = 0;
    int count = 0;

    for(int i=prices.length-1 ; i>0 && i>=prices.length - period ; i--) {
      sum += prices[i]['adjclose'];
      count++;
    }

    return sum / period;
  }
}