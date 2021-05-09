import 'package:flutter/material.dart';
import 'package:turing_deal/components/shared/tickerSearch.dart';
import 'package:turing_deal/data/model/ticker.dart';
import 'package:turing_deal/data/state/AppStateProvider.dart';
import 'package:turing_deal/screen/bigPictureScreen.dart';

class RootScreen extends StatelessWidget {
  final AppStateProvider _appState;

  const RootScreen(this._appState);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Turing deal'),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  List<Ticker> tickers = await showSearch(
                      context: context,
                      delegate: TickerSearch()
                  );

                  for(int i=0 ; i<tickers.length ; i++){
                    this._appState.search(tickers[i]);
                  }

                })
          ],
        ),
        body: Center(
            child: BigPictureScreen(_appState))
    );
  }
}