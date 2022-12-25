import 'package:flutter/material.dart';
import 'package:interactive_i18n/interactive_i18n.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/back_test_engine/model/strategy_result/buy_and_hold_strategyResult.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';
import 'package:turing_deal/home/ui/ticker_search.dart';
import 'package:turing_deal/market_data/model/stock_ticker.dart';
import 'package:turing_deal/market_data/static/ticker_resolve.dart';

class StrategyResumeHeader extends StatelessWidget {
  final StockTicker ticker;
  final BuyAndHoldStrategyResult? strategy;
  final double cardWidth;

  const StrategyResumeHeader(this.ticker, this.strategy, this.cardWidth);

  @override
  Widget build(BuildContext context) {
    final BigPictureStateProvider bigPictureState =
        Provider.of<BigPictureStateProvider>(context, listen: false);

    final ThemeData theme = Theme.of(context);

    final String ticketDescription = TickerResolve.getTickerDescription(ticker);

    final TickerSearch tickerSearch = TickerSearch(searchFieldLabel: 'Add'.t);

    return Container(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(children: [
            Row(
              mainAxisAlignment: bigPictureState.isCompactView()
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: bigPictureState.isCompactView()
                      ? cardWidth - 30
                      : cardWidth / 2 - 20,
                  child: Text(
                    ticker.symbol,
                    style: theme.textTheme.headline6,
                    textAlign: bigPictureState.isCompactView()
                        ? TextAlign.center
                        : TextAlign.start,
                  ),
                ),
                bigPictureState.isCompactView()
                    ? Container()
                    : SizedBox(
                        width: cardWidth / 2 - 20,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(ticketDescription,
                              style: theme.textTheme.bodyText1),
                        ))
              ],
            ),
            Divider(height: 5, color: theme.textTheme.bodyText1!.color),
            bigPictureState.isCompactView()
                ? Container()
                : const SizedBox(height: 10),
            bigPictureState.isCompactView()
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${strategy!.tradingYears.ceil()}y${(strategy!.tradingYears % 1 * 12).ceil()}m'),
                      strategy!.startDate != null && strategy!.endDate != null
                          ? Text('${DateFormat.yMd().format(strategy!.startDate!)} to ${DateFormat.yMd().format(strategy!.endDate!)}')
                          : Container()
                    ],
                  ),
            bigPictureState.isCompactView() ? Container() : const SizedBox(height: 10)
          ]),
          bigPictureState.isCompactView() || ticker.symbol.contains(',')
              ? Container()
              : InkWell(
                  child: Container(
                      color: Colors.lightBlue.withOpacity(0),
                      padding: EdgeInsets.only(
                          left: 40,
                          right: 40,
                          bottom: AppStateProvider.isDesktopWeb() ? 0 : 30),
                      child: const Icon(
                        Icons.add,
                      )),
                  onTap: () async {
                    final List<StockTicker>? tickers = await showSearch(
                        context: context, delegate: tickerSearch);
                    await bigPictureState.joinTicker(ticker, tickers);
                    await bigPictureState.persistTickers();
                  },
                ),
        ],
      ),
    );
  }
}
