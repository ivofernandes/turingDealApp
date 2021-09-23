import 'dart:math';

class CalculateDrawdown{
  /// Calculate the drawdown of the buy and hold strategy
  static double maxDrawdown(List<dynamic> prices) {
    double maxDrawdown = 0;
    double currentDrawdown = 0;
    double allTimeHigh = 0;

    for(int i=0 ; i<prices.length ; i++){
      double adjhigh = prices[i].high;
      double? adjlow = prices[i].low;

      // Update drawdown
      if (adjhigh > allTimeHigh) {
        allTimeHigh = adjhigh;
      }
      else {
        currentDrawdown = (adjlow! / allTimeHigh - 1) * 100;
      }

      maxDrawdown = min(maxDrawdown, currentDrawdown);
    }

    return maxDrawdown;
  }
}