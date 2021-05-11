import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turing_deal/data/model/ticker.dart';
import 'shared/connectivityState.dart';
import 'shared/navigationState.dart';

class AppStateProvider with ChangeNotifier, ConnectivityState, NavigationState {

  List<Ticker> searching = [];

  AppStateProvider(BuildContext context){
    //TODO the context is here to get user preferences in the future
  }

  void loadData() async{
    await initConnectivity();
  }

  void resetSearch(){
    this.searching = [];
  }

  void search(List<Ticker> search){
    this.searching = search;
    refresh();
  }

  List<Ticker> getSearching(){
    return this.searching;
  }

  void refresh() {
    notifyListeners();
  }

}
