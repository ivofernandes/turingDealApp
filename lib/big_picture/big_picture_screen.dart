import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:td_ui/src/shared/check_error.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/big_picture/ui/big_picture_scafold.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';

class BigPictureScreen extends StatefulWidget {
  const BigPictureScreen({
    super.key,
  });

  @override
  State<BigPictureScreen> createState() => _BigPictureScreenState();
}

class _BigPictureScreenState extends State<BigPictureScreen> {
  @override
  Widget build(BuildContext context) {
    final AppStateProvider appState = Provider.of<AppStateProvider>(context, listen: false);

    return Consumer<BigPictureStateProvider>(builder: (
      context,
      bigPictureState,
      child,
    ) {
      // Manage the transition of a search from the app state to a big picture screen state
      final List<StockTicker>? searchingTickers = appState.getSearching();

      if (bigPictureState.error != '') {
        return Center(
          child: Column(
            children: [
              Text(
                bigPictureState.error,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () => bigPictureState.loadData(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (searchingTickers != null && searchingTickers.isNotEmpty) {
        performSearch(context, bigPictureState, appState, searchingTickers);
      }

      return BigPictureScaffold();
    });
  }

  Future<void> performSearch(BuildContext context, BigPictureStateProvider bigPictureState, AppStateProvider appState,
      List<StockTicker> searchingTickers) async {
    final StockTicker ticker = searchingTickers.removeAt(0);
    try {
      await bigPictureState.addTicker(ticker);
      appState.refresh();
      await bigPictureState.persistTickers();
    } catch (error, st) {
      if (mounted) {
        CheckError.checkErrorState("Can't add the ticker ${ticker.symbol}, because of $error", context);
        debugPrint('Error: $error, StackTrace: $st');
      }
    }
  }
}
