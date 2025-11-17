import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:td_ui/td_ui.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';

class AddTickerButton extends StatelessWidget {
  final BigPictureStateProvider bigPictureState;
  final StockTicker currentTicker;
  final bool validTickerDescription;

  const AddTickerButton({
    required this.bigPictureState,
    required this.currentTicker,
    required this.validTickerDescription,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Align(
        alignment: validTickerDescription ? Alignment.topCenter : Alignment.topRight,
        child: InkWell(
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(left: 40, right: 40, bottom: AppTheme.isDesktopWeb() ? 0 : 30),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withAlpha((255 * 0.25).toInt()),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add),
            ),
          ),
          onTap: () async {
            final SearchResult? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TickerSearchPage(),
              ),
            );
            if (result != null) {
              final tickers = result.tickers.where((t) => t != currentTicker).toList();

              await bigPictureState.joinTicker(currentTicker, tickers);
              await bigPictureState.persistTickers();
            }
          },
        ),
      );
}
