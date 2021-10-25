import 'package:turing_deal/marketData/model/stock_picker.dart';

import 'tickers_list.dart';

class TickerResolve{
  static String getTickerDescription(StockTicker ticker) {
    if(ticker.description != null){
      return ticker.description!;
    }
    else{
      String symbol = ticker.symbol;

      if(TickersList.sectors[symbol] != null){
        return TickersList.sectors[symbol]!;
      } else if(TickersList.main[symbol] != null){
        return TickersList.main[symbol]!;
      } else if(TickersList.bonds[symbol] != null){
        return TickersList.bonds[symbol]!;
      } else if(TickersList.commodities[symbol] != null){
        return TickersList.commodities[symbol]!;
      } else if(TickersList.companies[symbol] != null){
        return TickersList.companies[symbol]!;
      } else if(TickersList.countries[symbol] != null){
        return TickersList.countries[symbol]!;
      }
      //TODO get from TickersList
      return symbol;
    }
  }
}