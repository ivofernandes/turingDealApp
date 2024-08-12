import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:td_ui/td_ui.dart';
import 'package:ticker_search/ticker_search.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/home/home_screen.dart';

/// A widget to display the header information for a strategy resume.
///
/// This includes the stock ticker information, strategy results, and an option
/// to add more details or change the current selection.
class StrategyResumeHeader extends StatelessWidget {
  final StockTicker ticker;
  final BuyAndHoldStrategyResult strategy;
  final double cardWidth;

  final double variation;

  final Color color;

  /// Constructs a [StrategyResumeHeader] widget.
  ///
  /// Takes in [ticker] for stock information, [strategy] for strategy results,
  /// and [cardWidth] to determine the width of the card.
  const StrategyResumeHeader({
    required this.ticker,
    required this.strategy,
    required this.cardWidth,
    required this.variation,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final BigPictureStateProvider bigPictureState = Provider.of<BigPictureStateProvider>(context, listen: false);
    final ThemeData theme = Theme.of(context);
    final String tickerDescription = TickerResolve.getTickerDescription(ticker);

    final double titleWidth = bigPictureState.isCompactView() ? cardWidth - 30 : cardWidth / 2 - 20;

    final PriceVariationChip priceVariationChip = PriceVariationChip(
      value: variation,
    );

    final bool validTickerDescription = ticker.symbol != tickerDescription && !bigPictureState.isCompactView();

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            if (validTickerDescription)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTickerTitle(titleWidth, theme, TextAlign.start),
                    SizedBox(
                      width: cardWidth / 2 - 30,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(tickerDescription, style: theme.textTheme.bodyLarge),
                      ),
                    ),
                  ],
                ),
              ),
            if (!validTickerDescription) _buildTickerTitle(titleWidth, theme, TextAlign.center),
            if (bigPictureState.isCompactView()) priceVariationChip,
            if (!bigPictureState.isCompactView())
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$${strategy.endPrice.toStringAsFixed(2)}'),
                  priceVariationChip,
                ],
              ),
            Divider(height: 5, color: theme.textTheme.bodyLarge?.color),
            if (!bigPictureState.isCompactView())
              Column(
                children: [
                  const SizedBox(height: 10),
                  _buildDateRow(),
                  const SizedBox(height: 10),
                ],
              ),
          ],
        ),
        if (!bigPictureState.isCompactView()) _buildAddButton(bigPictureState, context, validTickerDescription),
      ],
    );
  }

  /// Ticker symbol
  Widget _buildTickerTitle(double width, ThemeData theme, TextAlign textAlign) => Center(
        child: SizedBox(
          width: width,
          child: Text(
            ticker.symbol,
            style: theme.textTheme.titleLarge,
            textAlign: textAlign,
          ),
        ),
      );

  /// Builds the row displaying the strategy duration.
  ///
  /// Visible only in the expanded view mode.
  Widget _buildDateRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${strategy.tradingYears.ceil()}y${(strategy.tradingYears % 1 * 12).ceil()}m'),
          if (strategy.startDate != null && strategy.endDate != null)
            Text('${DateFormat.yMd().format(strategy.startDate!)} to ${DateFormat.yMd().format(strategy!.endDate!)}'),
        ],
      );

  /// Builds the add button for adding more details to the strategy.
  ///
  /// Visible only in the expanded view mode.
  Widget _buildAddButton(BigPictureStateProvider bigPictureState, BuildContext context, bool validTickerDescription) =>
      InkWell(
        child: Align(
          alignment: validTickerDescription ? Alignment.topCenter : Alignment.topRight,
          child: Container(
            color: Theme.of(context).colorScheme.surface.withOpacity(0),
            padding: EdgeInsets.only(left: 40, right: 40, bottom: AppTheme.isDesktopWeb() ? 0 : 30),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add),
            ),
          ),
        ),
        onTap: () async {
          final List<StockTicker>? tickers = await showSearch(
              context: context, delegate: TickerSearch(searchFieldLabel: 'Add'.t, suggestions: HomeScreen.suggestions));
          if (tickers != null) {
            await bigPictureState.joinTicker(ticker, tickers);
            await bigPictureState.persistTickers();
          }
        },
      );
}
