import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:ticker_details/src/state/ticker_state_provider.dart';
import 'package:ticker_details/src/ui/ticker_tabs.dart';

class TickerScreen extends StatelessWidget {
  final StockTicker ticker;

  const TickerScreen(
    this.ticker, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: FutureBuilder<dynamic>(
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
                  tickerState.startAnalysis(snapshot.data as List<YahooFinanceCandleData>);

                  return SafeArea(
                    child: TickerTabs(
                      ticker,
                      snapshot.data as List<YahooFinanceCandleData>,
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
}
