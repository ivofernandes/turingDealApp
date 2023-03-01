import 'package:flutter/foundation.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:turing_deal/home/state/mixins/connectivity_state.dart';
import 'package:turing_deal/home/state/mixins/theme_state.dart';

class AppStateProvider with ChangeNotifier, ConnectivityState, ThemeState {
  List<StockTicker>? searching = [];

  AppStateProvider() {
    final Future futureTheme = loadTheme();

    Future.wait([futureTheme]).then((value) => refresh());
  }

  Future<void> loadData() async {
    await initConnectivity();
  }

  void resetSearch() {
    searching = [];
  }

  void search(List<StockTicker>? search) {
    searching = search;
    refresh();
  }

  List<StockTicker>? getSearching() => searching;

  void refresh() {
    notifyListeners();
  }
}
