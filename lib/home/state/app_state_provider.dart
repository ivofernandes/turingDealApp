import 'package:flutter/foundation.dart';
import 'package:turing_deal/home/state/mixins/theme_state.dart';
import 'package:turing_deal/market_data/model/stock_ticker.dart';

import 'mixins/connectivity_state.dart';
import 'mixins/navigation_state.dart';

class AppStateProvider
    with ChangeNotifier, ConnectivityState, NavigationState, ThemeState {
  List<StockTicker>? searching = [];

  AppStateProvider() {
    Future futureTheme = loadTheme();

    Future.wait([futureTheme]).then((value) => refresh());
  }

  void loadData() async {
    await initConnectivity();
  }

  void resetSearch() {
    this.searching = [];
  }

  void search(List<StockTicker>? search) {
    this.searching = search;
    refresh();
  }

  List<StockTicker>? getSearching() {
    return this.searching;
  }

  void refresh() {
    notifyListeners();
  }

  static bool isDesktopWeb() {
    return kIsWeb &&
        (defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.android);
  }
}
