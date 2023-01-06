import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interactive_i18n/interactive_i18n.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:turing_deal/big_picture/big_picture_screen.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';
import 'package:turing_deal/home/ui/ticker_search.dart';
import 'package:turing_deal/settings/settings_screen.dart';
import 'package:turing_deal/shared/my_app_context.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppStateProvider appState =
        Provider.of<AppStateProvider>(context, listen: false);

    forcePortraitModeInPhones(context);

    final TickerSearch t = TickerSearch(searchFieldLabel: 'Search'.t);
    MyAppContext.context = context;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(SettingsScreen.route),
          icon: const Icon(Icons.menu),
        ),
        title: const Text('Turing deal'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                final List<StockTicker>? tickers = await showSearch(
                  context: context,
                  delegate: t,
                );

                appState.search(tickers);
              })
        ],
      ),
      body: Center(
        child: BigPictureScreen(
          key: UniqueKey(),
        ),
      ),
    );
  }

  void forcePortraitModeInPhones(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.height < 400 || size.width < 400) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }
}
