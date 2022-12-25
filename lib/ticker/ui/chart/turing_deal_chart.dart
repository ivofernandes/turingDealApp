import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:intl/intl.dart';
import 'package:turing_deal/shared/app_theme.dart';
import 'package:turing_deal/ticker/ui/chart/chart_legend.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class TuringDealChart extends StatelessWidget {
  final List<YahooFinanceCandleData> data;
  const TuringDealChart(this.data);

  @override
  Widget build(BuildContext context) {
    final List<CandleData> candleDataArray = [
      // timestamp, open, high, low, close, volume
    ];

    for (final YahooFinanceCandleData element in data) {
      final CandleData candle = CandleData(
          timestamp: element.date.millisecondsSinceEpoch,
          open: element.open,
          close: element.close,
          volume: element.volume.toDouble(),
          low: element.low,
          high: element.high);
      candleDataArray.add(candle);
    }

    final ma20 = CandleData.computeMA(candleDataArray, 20);
    final ma50 = CandleData.computeMA(candleDataArray, 50);
    final ma200 = CandleData.computeMA(candleDataArray, 200);

    for (int i = 0; i < data.length; i++) {
      candleDataArray[i].trends = [ma20[i], ma50[i], ma200[i]];
    }

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: InteractiveChart(
            candles: candleDataArray,
            style: ChartStyle(
              priceGainColor: Theme.of(context).colorScheme.primary,
              priceLossColor: Theme.of(context).colorScheme.error,
              trendLineStyles: [
                Paint()
                  ..strokeWidth = 2.0
                  ..strokeCap = StrokeCap.round
                  ..color = AppTheme.ma20,
                Paint()
                  ..strokeWidth = 3.0
                  ..strokeCap = StrokeCap.round
                  ..color = AppTheme.ma50,
                Paint()
                  ..strokeWidth = 4.0
                  ..strokeCap = StrokeCap.round
                  ..color = AppTheme.ma200,
              ],
            ),
            overlayInfo: overlayInfo,
            onTap: (candle) {
              print('candle clicked $candle');
            },
          ),
        ),
        const ChartLegend()
      ],
    );
  }

  Map<String, String> overlayInfo(CandleData candle) {
    final date = DateFormat.yMMMd()
        .format(DateTime.fromMillisecondsSinceEpoch(candle.timestamp));
    return {
      'Date': date,
      'Open': candle.open?.toStringAsFixed(2) ?? '-',
      'High': candle.high?.toStringAsFixed(2) ?? '-',
      'Low': candle.low?.toStringAsFixed(2) ?? '-',
      'Close': candle.close?.toStringAsFixed(2) ?? '-',
      'Volume': candle.volume?.asAbbreviated() ?? '-',
      'Moving average 20': candle.trends[0]?.toStringAsFixed(2) ?? '-',
      'Moving average 50': candle.trends[1]?.toStringAsFixed(2) ?? '-',
      'Moving average 200': candle.trends[2]?.toStringAsFixed(2) ?? '-'
    };
  }
}
