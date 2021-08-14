import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/marketData/model/ticker.dart';
import 'package:turing_deal/home/components/tickerSearch.dart';
import 'package:turing_deal/shared/state/AppStateProvider.dart';
import '../bigPicture/bigPictureScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context, listen: false);

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

                  appState.search(tickers);
                })
          ],
        ),
        body: Center(
            child: BigPictureScreen())
    );
  }
}