import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interactive_i18n/interactive_i18n.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';
import 'package:turing_deal/home/ui/ticker_search.dart';
import 'package:turing_deal/market_data/model/stock_ticker.dart';
import 'package:turing_deal/shared/my_app_context.dart';

import '../big_picture/big_picture_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState =
        Provider.of<AppStateProvider>(context, listen: false);

    forcePortraitModeInPhones(context);

    TickerSearch t = TickerSearch(searchFieldLabel: 'Search'.t);
    MyAppContext.context = context;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(SettingsScreen.route),
          icon: Icon(Icons.menu),
        ),
        title: Text('Turing deal'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                List<StockTicker>? tickers =
                    await showSearch(context: context, delegate: t);

                appState.search(tickers);
              })
        ],
      ),
      body: Center(
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
