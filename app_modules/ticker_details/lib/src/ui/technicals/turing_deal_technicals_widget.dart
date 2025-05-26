import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:ticker_details/src/ui/technicals/add_indicator_widget.dart';
import 'package:ticker_details/src/ui/technicals/present_indicator_widget.dart';

class TuringDealTechnicalsWidget extends StatefulWidget {
  final List<YahooFinanceCandleData> prices;

  const TuringDealTechnicalsWidget(
    this.prices, {
    super.key,
  });

  @override
  State<TuringDealTechnicalsWidget> createState() => _TuringDealTechnicalsWidgetState();
}

class _TuringDealTechnicalsWidgetState extends State<TuringDealTechnicalsWidget> {
  static List<String> indicatorsList = ['SMA', 'EMA', 'RSI', 'BB', 'MFI', 'STDDEV', 'VWMA', '%R'];

  List<String> indicators = [
    'EMA_3',
    'EMA_30',
    'SMA_2000',
    'RSI_200',
    'RSI_50',
    'RSI_20',
    'BB_20',
    'MFI_20',
    'STDDEV_20',
    'VWMA_20',
    '%R_20'
  ];

  void _addIndicator(String indicator, int period) {
    setState(() {
      indicators.add('${indicator}_$period');
    });
  }

  void _removeIndicator(String indicator) {
    setState(() {
      indicators.remove(indicator);
    });
  }

  @override
  Widget build(BuildContext context) {
    CalculateIndicators.calculateIndicators(widget.prices, indicators);
    final YahooFinanceCandleData candleData = widget.prices.last;
    final Map<String, double> prices = candleData.indicators;
    final List<String> indicatorsCalculated = prices.keys.toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          // Widget to show the values of the indicators
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                ListTile(
                  title: Text('Current Price'.t),
                  trailing: Text(candleData.adjClose.toStringAsFixed(2)),
                ),
                ...indicatorsCalculated.map((indicator) {
                  if (!prices.containsKey(indicator)) {
                    return Container();
                  }

                  return Dismissible(
                    background: const ColoredBox(
                      color: Colors.red,
                      child: Icon(Icons.delete),
                    ),
                    key: Key(indicator),
                    onDismissed: (direction) {
                      _removeIndicator(indicator);
                    },
                    child: PresentIndicatorWidget(
                      indicator: indicator,
                      value: getValueForIndicator(indicator, prices),
                      currentPrice: candleData.adjClose,
                    ),
                  );
                }).toList(),
              ]),
            ),
          ),
          // AddIndicatorWidget
          AddIndicatorWidget(
            indicatorsList: indicatorsList,
            onAddIndicator: _addIndicator,
          ),
        ],
      ),
    );
  }

  double getValueForIndicator(String indicator, Map<String, double> prices) {
    print('indicator: $indicator');
    return prices[indicator]!;
  }
}
