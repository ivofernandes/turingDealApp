import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_edgar_sec/flutter_edgar_sec.dart';
import 'package:ticker_details/src/ui/analysis/turing_deal_analysis.dart';
import 'package:ticker_details/src/ui/chart/turing_deal_chart.dart';
import 'package:ticker_details/src/ui/details/list_prices_text_ui.dart';
import 'package:ticker_details/src/ui/fundamentals/turing_deal_fundamentals_widget.dart';
import 'package:ticker_details/src/ui/technicals/turing_deal_technicals_widget.dart';

class TickerTabs extends StatefulWidget {
  final StockTicker ticker;
  final List<YahooFinanceCandleData> data;
  final bool hasFundamentals;

  const TickerTabs(
    this.ticker,
    this.data, {
    this.hasFundamentals = true,
    super.key,
  });

  @override
  State<TickerTabs> createState() => _TickerTabsState();
}

class _TickerTabsState extends State<TickerTabs> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> bottomSheetItems = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.show_chart_outlined),
        label: 'Chart'.t,
      ),
      ...widget.hasFundamentals
          ? [
              BottomNavigationBarItem(
                icon: const Icon(Icons.foundation),
                label: 'Fundamentals'.t,
              ),
            ]
          : [],
      BottomNavigationBarItem(
        icon: const Icon(Icons.biotech),
        label: 'Technicals'.t,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.analytics_outlined),
        label: 'Analysis'.t,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.list),
        label: 'Prices'.t,
      ),
    ];

    final String titleDescription = TickerResolve.getTickerDescription(widget.ticker);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titleDescription,
        ),
        actions: actions(),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            TuringDealChart(widget.data),
            ...widget.hasFundamentals
                ? [
                    TuringDealFundamentalsWidget(
                      widget.ticker.symbol,
                    ),
                  ]
                : [],
            TuringDealTechnicalsWidget(
              widget.data,
            ),
            TuringDealAnalysis(
              key: UniqueKey(),
            ),
            ListPricesText((widget.data).reversed.toList())
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemSelected,
        currentIndex: _selectedIndex,
        items: bottomSheetItems,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  void _onItemSelected(int index) {
    setState(
      () {
        _pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
        _selectedIndex = index;
      },
    );
    print(index.toString());
  }

  List<Widget> actions() {
    switch (_selectedIndex) {
      case 1:
        return [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text(
                        TickerResolve.getTickerDescription(widget.ticker) + ' Fundamentals',
                      ),
                    ),
                    body: SingleChildScrollView(
                      child: CompanyChartUI(
                        symbol: widget.ticker.symbol,
                      ),
                    ),
                  ),
                ),
              );
            },
            icon: Icon(Icons.show_chart_outlined),
          ),
        ];
      default:
        return [];
    }
  }
}
