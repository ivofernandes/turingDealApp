import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/big_picture/ui/big_picture_scafold.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';
import 'package:turing_deal/shared/ui/checkError.dart';

class BigPictureScreen extends StatelessWidget {
  const BigPictureScreen();

  @override
  Widget build(BuildContext context) {
    final AppStateProvider appState =
        Provider.of<AppStateProvider>(context, listen: false);

    return Consumer<BigPictureStateProvider>(
        builder: (context, bigPictureState, child) {
      // Manage the transition of a search from the app state to a big picture screen state
      final List<StockTicker>? searchingTickers = appState.getSearching();

      if (searchingTickers != null && searchingTickers.isNotEmpty) {
        final StockTicker ticker = searchingTickers.removeAt(0);
        bigPictureState
            .addTicker(ticker)
            .then((value) => bigPictureState.persistTickers())
            .onError((error, stackTrace) {
          CheckError.checkErrorState(
              "Can't add the ticker ${ticker.symbol}, because of $error",
              context);
        });
      }

      return BigPictureScaffold(
        key: UniqueKey(),
      );
    });
  }
}
