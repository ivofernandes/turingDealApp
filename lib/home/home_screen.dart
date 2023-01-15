import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interactive_i18n/interactive_i18n.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:turing_deal/big_picture/big_picture_screen.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';
import 'package:turing_deal/home/ui/ticker_search.dart';
import 'package:turing_deal/portfolio/portfolio_screen.dart';
import 'package:turing_deal/settings/settings_screen.dart';
import 'package:turing_deal/shared/my_app_context.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const duration = Duration(milliseconds: 200);
  static const curve = Curves.ease;

  int _index = 1;
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
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageViewController,
        children: [
          Center(
            child: BigPictureScreen(
              key: UniqueKey(),
            ),
          ),
          Center(
            child: PortfolioScreen(
              key: UniqueKey(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Research',
            icon: Icon(
              Icons.show_chart,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Portfolio',
            icon: Icon(
              Icons.work,
            ),
          ),
        ],
        currentIndex: _index,
        onTap: onItemSelected,
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
