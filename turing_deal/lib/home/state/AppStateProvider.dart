import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turing_deal/marketData/model/stockTicker.dart';
import 'mixins/connectivityState.dart';
import 'mixins/navigationState.dart';

class AppStateProvider with ChangeNotifier, ConnectivityState, NavigationState {

  List<StockTicker>? searching = [];

  AppStateProvider(BuildContext context){
    //TODO the context is here to get user preferences in the future
  }

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
