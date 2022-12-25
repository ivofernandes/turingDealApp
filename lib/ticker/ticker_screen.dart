import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/market_data/model/stock_ticker.dart';
import 'package:turing_deal/ticker/state/ticker_state_provider.dart';
import 'package:turing_deal/ticker/ui/ticker_tabs.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class TickerScreen extends StatelessWidget {
  StockTicker ticker;

  TickerScreen(this.ticker);

  @override
  Widget build(BuildContext context) => FutureBuilder<dynamic>(
        future: YahooFinanceService().getTickerData(ticker.symbol),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ChangeNotifierProvider(
              create: (context) => TickerStateProvider(),
              child: Consumer<TickerStateProvider>(
                  builder: (context, tickerState, child) {
                tickerState.startAnalysis(
                    snapshot.data as List<YahooFinanceCandleData>);

                return SafeArea(
                    child: TickerTabs(ticker,
                        snapshot.data as List<YahooFinanceCandleData>));
              }));
        });
}
