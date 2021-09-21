import 'package:backdrop/backdrop.dart';
import 'package:backdrop/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/marketData/model/stockTicker.dart';
import 'package:turing_deal/home/ui/tickerSearch.dart';
import 'package:turing_deal/home/state/AppStateProvider.dart';
import '../bigPicture/bigPictureScreen.dart';
import 'menu/menuComponent.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState =
        Provider.of<AppStateProvider>(context, listen: false);

    forcePortraitModeInPhones(context);


    return BackdropScaffold(
      appBar: BackdropAppBar(
        title: Text('Turing deal'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                List<StockTicker>? tickers = await showSearch(
                    context: context, delegate: TickerSearch());

                appState.search(tickers);
              })
        ],
      ),
      backLayer: MenuComponent(),
      frontLayer: Center(
        child: BigPictureScreen(),
      ),
    );

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
