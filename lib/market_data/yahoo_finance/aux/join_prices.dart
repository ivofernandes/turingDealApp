class JoinPrices {
  /// Join [oldPricesList] with the [recentPricesList]
  ///
  /// [oldPricesList]
  ///
  static List<dynamic> joinPrices(
      List<dynamic> oldPricesList, List<dynamic> recentPricesList) {
    double proportion = _calculateProportion(oldPricesList, recentPricesList);

    if (proportion != 1) {
      List<Map<dynamic, dynamic>> oldPricesListMutable =
          oldPricesList.map((e) => Map.of(e)).toList();

      print(
          'Found porportion != 1: ' + recentPricesList.last['date'].toString());
      for (int i = 0; i < oldPricesList.length; i++) {
        if (oldPricesListMutable[i].containsKey('adjclose') &&
            oldPricesListMutable[i]['adjclose'] != null) {
          oldPricesListMutable[i]['adjclose'] =
              oldPricesListMutable[i]['adjclose'] * proportion;
        }
      }

      return _finishJoin(oldPricesListMutable, recentPricesList, proportion);
    } else {
      return _finishJoin(oldPricesList, recentPricesList, proportion);
    }
  }

  static double _calculateProportion(
      List oldPricesList, List recentPricesList) {
    //Get the index on prices that matches the last value in next prices

    int indexInOld = 0;
    int indexInRecent = recentPricesList.length;

    bool foundMatch = false;

    // Start in the last recent index of the recent dataframe
    // and goes on searching for a date in the old dataframe that matches
    while (!foundMatch && indexInRecent != 0) {
      indexInRecent--;
      indexInOld = 0;

      DateTime oldestDateInTheRecentList = DateTime.fromMillisecondsSinceEpoch(
          recentPricesList[indexInRecent]['date'] * 1000);

      while (indexInOld < oldPricesList.length - 1 &&
          recentPricesList[indexInRecent]['date'] !=
              oldPricesList[indexInOld]['date'] &&
          indexInOld < oldPricesList.length) {
        indexInOld++;

        DateTime referenceDate = DateTime.fromMillisecondsSinceEpoch(
            oldPricesList[indexInOld]['date'] * 1000);
        print('reference date: $referenceDate');
      }

      //
      foundMatch = recentPricesList[indexInRecent]['date'] ==
          oldPricesList[indexInOld]['date'];
    }

    double proportion = 1;

    if (foundMatch) {
      // Check if there is a need to apply a porportion adjustment int ehe adjusted close
      proportion = recentPricesList[indexInRecent]['adjclose'] /
          oldPricesList[indexInOld]['adjclose'];
    }

    return proportion;
  }

  static List<dynamic> _finishJoin(
      List oldPricesList, List recentPricesList, double porportion) {
    List<dynamic> result = oldPricesList.toList();

    // Will check if is has the same day than the old date limit,
    // because it can be incomplete as the close data is not from close
    // but rather the last price in the time of the request
    DateTime oldLimitDate =
        DateTime.fromMillisecondsSinceEpoch(result.first['date'] * 1000);
    String oldLimitDateString = oldLimitDate.toIso8601String().split('T')[0];
    bool overridedLast = false;

    // join the next prices into the prices array
    for (int i = recentPricesList.length - 1; i >= 0; i--) {
      if (recentPricesList[i]['date'] < result.first['date']) {
        continue;
      }

      if (!overridedLast) {
        DateTime currentDate = DateTime.fromMillisecondsSinceEpoch(
            recentPricesList[i]['date'] * 1000);
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
