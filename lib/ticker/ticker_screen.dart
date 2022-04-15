import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/market_data/model/candle_price.dart';
import 'package:turing_deal/market_data/model/stock_ticker.dart';
import 'package:turing_deal/market_data/yahoo_finance/services/yahoo_finance_service.dart';
import 'package:turing_deal/ticker/state/ticker_state_provider.dart';
import 'package:turing_deal/ticker/ui/ticker_tabs.dart';

class TickerScreen extends StatelessWidget {
  StockTicker ticker;

  TickerScreen(this.ticker);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: YahooFinanceService.getTickerData(this.ticker),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ChangeNotifierProvider(
              create: (context) => TickerStateProvider(),
              child: Consumer<TickerStateProvider>(
                  builder: (context, tickerState, child) {
                tickerState.startAnalysis(snapshot.data as List<CandlePrice>);

                return SafeArea(
                    child: TickerTabs(
                        this.ticker, snapshot.data as List<CandlePrice>));
              }));
        });
  }
}
