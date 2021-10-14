class JoinPrices{
  /// Join [oldPricesList] with the [recentPricesList]
  ///
  /// [oldPricesList]
  ///
  static List<dynamic> joinPrices(List<dynamic> oldPricesList, List<dynamic> recentPricesList) {
    //Get the index on prices that matches the last value in next prices
    int oldestDateInTheRecentList = recentPricesList.last['date'];
    int indexToStart = 0;
    while(oldPricesList[indexToStart]['date'] != oldestDateInTheRecentList && indexToStart < oldPricesList.length){
      indexToStart++;
    }
    print('reference date: ' + oldPricesList[indexToStart]['date'].toString());

    // Check if there is a need to apply a porportion adjustment int ehe adjusted close
    double porportion = recentPricesList.last['adjclose'] / oldPricesList[indexToStart]['adjclose'];

    if(porportion != 1){
      print('Found porportion != 1: ' + recentPricesList.last['date'].toString());
      for(int i=0 ; i<oldPricesList.length ; i++){
        oldPricesList[i]['adjclose'] *= porportion;
      }
    }

    return finishJoin(oldPricesList, recentPricesList, porportion);
  }

  static List<dynamic> finishJoin(List oldPricesList, List recentPricesList, double porportion) {
    List<dynamic> result = oldPricesList.toList();

    // Will check if is has the same day than the old date limit,
    // because it can be incomplete as the close data is not from close
    // but rather the last price in the time of the request
    DateTime oldLimitDate =
      DateTime.fromMillisecondsSinceEpoch(result.first['date'] * 1000);
    String oldLimitDateString = oldLimitDate.toIso8601String().split('T')[0];
    bool overridedLast = false;

    // join the next prices into the prices array
    for(int i=recentPricesList.length-1 ; i >= 0 ; i--){
      if(recentPricesList[i]['date'] < result.first['date']){
        continue;
      }

      if(!overridedLast) {
        DateTime currentDate =
        DateTime.fromMillisecondsSinceEpoch(recentPricesList[i]['date'] * 1000);
        String currentDateString = currentDate.toIso8601String().split('T')[0];

        if (currentDateString == oldLimitDateString) {
          result[0] = recentPricesList[i];
          overridedLast = true;
          continue;
        }
      }

      result.insert(0, recentPricesList[i]);
    }

    return result;
  }
}