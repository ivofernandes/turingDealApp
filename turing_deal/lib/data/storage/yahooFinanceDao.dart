import 'package:sembast/sembast.dart';
import 'package:turing_deal/data/storage/sembastDatabase.dart';

class YahooFinanceDAO with SembastDatabase{
  // Singleton
  static final YahooFinanceDAO _singleton = YahooFinanceDAO._internal();
  factory YahooFinanceDAO() {
    return _singleton;
  }
  YahooFinanceDAO._internal();

  static String STORE_DAILY = 'YAHOO_DAILY';

  Future<List<dynamic>> getAllDailyData(String ticker) async{
    var store = intMapStoreFactory.store(STORE_DAILY);

    var data = await store.find(getDatabase(), finder: Finder(
        filter:Filter.equals('ticker', ticker)
    ));

    List<dynamic> resultsList = [];

    data.forEach((snapshot) {
      var map = snapshot.value;

      resultsList = map['data'];
    });

    return resultsList;
  }

  Future<int> saveDailyData(String ticker, List<dynamic> data) async{

    var store = intMapStoreFactory.store(STORE_DAILY);

    await store.delete(getDatabase(),
        finder: Finder(filter: Filter.equals('ticker', ticker)));

    await store.add(getDatabase(), {'ticker': ticker,'data': data});
  }

}
