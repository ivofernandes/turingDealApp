import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/big_picture/ui/big_picture_scafold.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';
import 'package:turing_deal/market_data/model/stock_ticker.dart';
import 'package:turing_deal/shared/ui/checkError.dart';

import './state/big_picture_state_provider.dart';

class BigPictureScreen extends StatelessWidget {
  BigPictureScreen();

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState =
        Provider.of<AppStateProvider>(context, listen: false);

    return Consumer<BigPictureStateProvider>(
        builder: (context, bigPictureState, child) {
      // Manage the transition of a search from the app state to a big picture screen state
      List<StockTicker>? searchingTickers = appState.getSearching();

      if (searchingTickers != null && searchingTickers.isNotEmpty) {
        StockTicker ticker = searchingTickers.removeAt(0);
        bigPictureState
            .addTicker(ticker)
            .then((value) => bigPictureState.persistTickers())
            .onError((error, stackTrace) {
          CheckError.checkErrorState(
              'Can\'t add the ticker ' +
                  ticker.symbol +
                  ', because of ' +
                  error.toString(),
              context);
        });
      }

      return BigPictureScaffold();
    });
  }
}
