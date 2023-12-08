import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interactive_i18n/interactive_i18n.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:stocks_portfolio/stocks_portfolio.dart';
import 'package:td_ui/td_ui.dart';
import 'package:ticker_search/ticker_search.dart';
import 'package:turing_deal/big_picture/big_picture_screen.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';
import 'package:turing_deal/settings/settings_screen.dart';
import 'package:turing_deal/shared/environment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  static List<TickerSuggestion> suggestions = [
    TickerSuggestion(const Icon(Icons.view_headline), 'Main'.t, TickersList.main),
    TickerSuggestion(const Icon(Icons.business_sharp), 'Companies'.t, TickersList.companies),
    TickerSuggestion(const Icon(Icons.precision_manufacturing_outlined), 'Sectors'.t, TickersList.sectors),
    TickerSuggestion(const Icon(Icons.workspaces_outline), 'Futures'.t, TickersList.futures),
    TickerSuggestion(const Icon(Icons.computer), 'Cryptos'.t, TickersList.cryptoCurrencies),
    TickerSuggestion(const Icon(Icons.language), 'Countries'.t, TickersList.countries),
    TickerSuggestion(const Icon(Icons.account_balance_outlined), 'Bonds', TickersList.bonds),
    TickerSuggestion(const Icon(Icons.architecture_sharp), 'Sizes'.t, TickersList.sizes),
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const duration = Duration(milliseconds: 200);
  static const curve = Curves.ease;

  int _index = 0;
  final PageController _pageViewController = PageController();

  @override
  void initState() {
    super.initState();

    if (_index != 0) {
      Future.delayed(
        Duration.zero,
        () => _pageViewController.jumpToPage(_index),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppStateProvider appState = Provider.of<AppStateProvider>(context, listen: false);
    final BigPictureStateProvider bigPictureState = Provider.of<BigPictureStateProvider>(context, listen: false);

    forcePortraitModeInPhones(context);

    MyAppContext.context = context;

    return MyScaffold(
      nav: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(SettingsScreen.route),
            icon: const Icon(Icons.menu),
          ),
          IconButton(
            onPressed: () {
              onItemSelected(0);
            },
            icon: const Icon(
              Icons.show_chart,
            ),
          ),
          if (Environment.hasPortfolio)
            IconButton(
              onPressed: () {
                onItemSelected(1);
              },
              icon: const Icon(
                Icons.work,
              ),
            ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final List<StockTicker>? tickers = await showSearch(
                context: context,
                delegate: TickerSearch(
                  searchFieldLabel: 'Search'.t,
                  suggestions: HomeScreen.suggestions,
                ),
              );

              appState.search(tickers);
            },
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageViewController,
        children: [
          Center(
            child: BigPictureScreen(
              key: UniqueKey(),
            ),
          ),
          if (Environment.hasPortfolio)
            Center(
              child: PortfolioScreen(
                stocks: bigPictureState.getBigPictureData(),
              ),
            ),
        ],
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

  void onItemSelected(int value) {
    _index = value;
    _pageViewController.animateToPage(
      value,
      duration: duration,
      curve: curve,
    );
    setState(() {});
  }
}
