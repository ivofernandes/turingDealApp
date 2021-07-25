import 'package:flutter/material.dart';
import 'package:turing_deal/marketData/model/ticker.dart';
import 'package:turing_deal/shared/components/tickerSearch.dart';
import 'package:turing_deal/shared/state/AppStateProvider.dart';
import '../bigPicture/bigPictureScreen.dart';

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
                  List<Ticker>? tickers = await showSearch(
                      context: context,
                      delegate: TickerSearch()
                  );

                  this._appState.search(tickers);
                })
          ],
        ),
        body: Center(
            child: BigPictureScreen(_appState))
    );
  }
}