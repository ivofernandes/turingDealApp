import 'package:flutter/material.dart';
import 'package:interactive_i18n/interactive_i18n.dart';
import 'package:turing_deal/market_data/model/stock_ticker.dart';
import 'package:turing_deal/market_data/static/ticker_resolve.dart';
import 'package:turing_deal/ticker/ui/analysis/turing_deal_analysis.dart';
import 'package:turing_deal/ticker/ui/chart/turing_deal_chart.dart';
import 'package:turing_deal/ticker/ui/details/list_prices_text_ui.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class TickerTabs extends StatefulWidget {
  final StockTicker ticker;
  final List<YahooFinanceCandleData> data;

  const TickerTabs(this.ticker, this.data, {super.key});

  @override
  State<TickerTabs> createState() => _TickerTabsState();
}

class _TickerTabsState extends State<TickerTabs> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          title: Text(TickerResolve.getTickerDescription(widget.ticker))),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: _onItemSelected,
            children: [
              TuringDealChart(widget.data),
              const TuringDealAnalysis(),
              ListPricesText((widget.data).reversed.toList())
            ],
          )),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemSelected,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.show_chart_outlined),
            label: 'Chart'.t,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics_outlined),
            label: 'Analysis'.t,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: 'Prices'.t,
          ),
        ],
      ),
    );

  void _onItemSelected(int index) {
    setState(() {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      _selectedIndex = index;
    });
    print(index.toString());
  }
}
