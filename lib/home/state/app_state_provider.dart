import 'package:flutter/foundation.dart';
import 'package:turing_deal/home/state/mixins/connectivity_state.dart';
import 'package:turing_deal/home/state/mixins/navigation_state.dart';
import 'package:turing_deal/home/state/mixins/theme_state.dart';
import 'package:turing_deal/market_data/model/stock_ticker.dart';

class AppStateProvider
    with ChangeNotifier, ConnectivityState, NavigationState, ThemeState {
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

  static bool isDesktopWeb() => kIsWeb &&
        (defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.android);
}
