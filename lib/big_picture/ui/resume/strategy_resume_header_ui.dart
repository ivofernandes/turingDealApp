import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:td_ui/td_ui.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/big_picture/ui/resume/header/add_ticker_button.dart';
import 'package:turing_deal/big_picture/ui/resume/header/ticker_title.dart';

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

    final bool validTickerDescription = ticker.symbol != tickerDescription && !bigPictureState.isCompactView();

    final priceVariationChip = PriceVariationChip(value: variation);

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
                    TickerTitle(ticker: ticker, width: titleWidth, textAlign: TextAlign.start),
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
            if (!validTickerDescription) TickerTitle(ticker: ticker, width: titleWidth, textAlign: TextAlign.center),
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
        if (!bigPictureState.isCompactView())
          AddTickerButton(
            bigPictureState: bigPictureState,
            currentTicker: ticker,
            validTickerDescription: validTickerDescription,
          ),
      ],
    );
  }

  Widget _buildDateRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${strategy.tradingYears.ceil()}y${(strategy.tradingYears % 1 * 12).ceil()}m'),
          if (strategy.startDate != null && strategy.endDate != null)
            Text('${DateFormat.yMd().format(strategy.startDate!)} to ${DateFormat.yMd().format(strategy.endDate!)}'),
        ],
      );
}
