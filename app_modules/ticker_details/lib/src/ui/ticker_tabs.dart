import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ticker_details/src/ui/analysis/turing_deal_analysis.dart';
import 'package:ticker_details/src/ui/chart/turing_deal_chart.dart';
import 'package:ticker_details/src/ui/details/list_prices_text_ui.dart';

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
        appBar: AppBar(title: Text(TickerResolve.getTickerDescription(widget.ticker))),
        body: Container(
            padding: const EdgeInsets.all(20),
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: _onItemSelected,
              children: [
                TuringDealChart(widget.data),
                TuringDealAnalysis(
                  key: UniqueKey(),
                ),
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
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      _selectedIndex = index;
    });
    print(index.toString());
  }
}
