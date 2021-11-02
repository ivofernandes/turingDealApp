import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';
import 'package:turing_deal/market_data/model/stock_picker.dart';
import 'package:turing_deal/market_data/static/ticker_resolve.dart';
import 'package:turing_deal/market_data/yahoo_finance/services/yahoo_finance_service.dart';
import 'package:turing_deal/ticker/chart/turing_deal_chart.dart';

import 'details/list_prices_text_ui.dart';

class TickerScreen extends StatefulWidget {
  StockTicker ticker;

  TickerScreen(this.ticker);

  @override
  State<TickerScreen> createState() => _TickerScreenState();
}

class _TickerScreenState extends State<TickerScreen> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<dynamic>(
        future: YahooFinanceService.getTickerData(this.widget.ticker),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  title: Text(TickerResolve.getTickerDescription(this.widget.ticker))
                ),
                body: snapshot.data == null
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                      padding: const EdgeInsets.all(20.0),
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: _onItemSelected,
                        children: [
                          TuringDealChart(snapshot.data as List<CandlePrice>),
                          ListPricesText((snapshot.data as List<CandlePrice>).reversed.toList())
                        ],
                      )
                    ),
              bottomNavigationBar: BottomNavigationBar(
                onTap: _onItemSelected,
                currentIndex: _selectedIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.show_chart_outlined),
                    label: 'Chart'
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.list),
                      label: 'Prices'
                  ),
                ],
              ),
        ),
          );
      }
    );
  }

  void _onItemSelected(int index){
    setState(() {
      _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut);
      _selectedIndex = index;
    });
    print(index.toString());
  }
}