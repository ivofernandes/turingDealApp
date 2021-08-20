import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/marketData/model/ticker.dart';
import 'package:turing_deal/home/components/tickerSearch.dart';
import 'package:turing_deal/home/state/AppStateProvider.dart';
import '../bigPicture/bigPictureScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState =
        Provider.of<AppStateProvider>(context, listen: false);

    forcePortraitModeInPhones(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Turing deal'),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  List<Ticker>? tickers = await showSearch(
                      context: context, delegate: TickerSearch());

                  appState.search(tickers);
                })
          ],
        ),
        body: Center(child: BigPictureScreen()));
  }

  void forcePortraitModeInPhones(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (size.height < 400 || size.width < 400) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }
}
