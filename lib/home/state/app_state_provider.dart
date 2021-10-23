import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turing_deal/marketData/model/stock_picker.dart';
import 'mixins/connectivity_state.dart';
import 'mixins/navigation_state.dart';

class AppStateProvider with ChangeNotifier, ConnectivityState, NavigationState {

  List<StockTicker>? searching = [];

  void loadData() async{
    await initConnectivity();
  }

  void resetSearch(){
    this.searching = [];
  }

  void search(List<StockTicker>? search){
    this.searching = search;
    refresh();
  }

  List<StockTicker>? getSearching(){
    return this.searching;
  }

  void refresh() {
    notifyListeners();
  }

}
