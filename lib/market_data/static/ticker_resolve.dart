import 'package:turing_deal/market_data/model/stock_ticker.dart';

import 'package:turing_deal/market_data/static/tickers_list.dart';

class TickerResolve {
  static String getTickerDescription(StockTicker ticker) {
    if (ticker.description != null) {
      return ticker.description!;
    } else {
      final String symbol = ticker.symbol;

      if (TickersList.sectors[symbol] != null) {
        return TickersList.sectors[symbol]!;
      } else if (TickersList.main[symbol] != null) {
        return TickersList.main[symbol]!;
      } else if (TickersList.bonds[symbol] != null) {
        return TickersList.bonds[symbol]!;
      } else if (TickersList.futures[symbol] != null) {
        return TickersList.futures[symbol]!;
      } else if (TickersList.companies[symbol] != null) {
        return TickersList.companies[symbol]!;
      } else if (TickersList.countries[symbol] != null) {
        return TickersList.countries[symbol]!;
      }
      //TODO get from TickersList
      return symbol;
    }
  }
}
