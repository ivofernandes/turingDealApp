import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';

class TickerTitle extends StatelessWidget {
  final StockTicker ticker;
  final double width;
  final TextAlign textAlign;

  const TickerTitle({
    required this.ticker,
    required this.width,
    required this.textAlign,
    super.key,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        child: Center(
          child: SizedBox(
            width: width,
            child: Text(
              ticker.symbol,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: textAlign,
            ),
          ),
        ),
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) => EditTickerProportionsDialog(ticker: ticker),
          );
        },
      );
}

class EditTickerProportionsDialog extends StatefulWidget {
  final StockTicker ticker;

  const EditTickerProportionsDialog({
    required this.ticker,
    super.key,
  });

  @override
  State<EditTickerProportionsDialog> createState() => _EditTickerProportionsDialogState();
}

class _EditTickerProportionsDialogState extends State<EditTickerProportionsDialog> {
  late List<String> _symbols;
  late List<double> _weights;

  @override
  void initState() {
    super.initState();
    _parseSymbolsAndWeights();
  }

  void _parseSymbolsAndWeights() {
    final String symbolStr = widget.ticker.symbol;
    final List<String> parts = symbolStr.split(',');

    _symbols = <String>[];
    _weights = <double>[];

    for (final String part in parts) {
      final String trimmed = part.trim();
      final List<String> subParts = trimmed.split('-');
      _symbols.add(subParts[0]);
      if (subParts.length > 1) {
        final double? w = double.tryParse(subParts[1]);
        _weights.add(w ?? (1.0 / parts.length));
      } else {
        _weights.add(1.0 / parts.length);
      }
    }
    _normalizeWeights();
  }

  void _normalizeWeights() {
    double total = 0;
    for (final double w in _weights) {
      total += w;
    }
    if (total == 0) {
      final double equal = 1.0 / _weights.length;
      for (int i = 0; i < _weights.length; i++) {
        _weights[i] = equal;
      }
    } else {
      for (int i = 0; i < _weights.length; i++) {
        _weights[i] = _weights[i] / total;
      }
    }
  }

  void _onSliderChanged(int index, double newValue) {
    final int n = _weights.length;
    if (n == 1) {
      setState(() {
        _weights[0] = 1.0;
      });
      return;
    }

    newValue = newValue.clamp(0.0, 1.0);

    final double othersTotal = _weights
        .asMap()
        .entries
        .where((entry) => entry.key != index)
        .fold<double>(0.0, (sum, entry) => sum + entry.value);

    final double remaining = (1.0 - newValue).clamp(0.0, 1.0);

    setState(() {
      _weights[index] = newValue;
      if (othersTotal == 0) {
        // Distribute equally among the others
        final double each = remaining / (n - 1);
        for (int i = 0; i < n; i++) {
          if (i != index) {
            _weights[i] = each;
          }
        }
      } else {
        // Scale other weights proportionally to fit the remaining total
        for (int i = 0; i < n; i++) {
          if (i == index) {
            continue;
          }
          final double ratio = _weights[i] / othersTotal;
          _weights[i] = remaining * ratio;
        }
      }
    });
  }

  double get _totalWeight {
    return _weights.fold<double>(0.0, (sum, w) => sum + w);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit proportions'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < _symbols.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_symbols[i]} (${_weights[i].toStringAsFixed(2)})'),
                Slider(
                  value: _weights[i].clamp(0.0, 1.0),
                  min: 0.0,
                  max: 1.0,
                  divisions: 100,
                  label: _weights[i].toStringAsFixed(2),
                  onChanged: (double value) => _onSliderChanged(i, value),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Text('Total: ${_totalWeight.toStringAsFixed(2)} (must be 1.00)'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // Build new proportions map
            final Map<String, double> newProportions = <String, double>{};
            for (int i = 0; i < _symbols.length; i++) {
              newProportions[_symbols[i]] = _weights[i];
            }

            final String combinedSymbol =
                newProportions.entries.map((entry) => '${entry.key}-${entry.value.toStringAsFixed(2)}').join(', ');

            await context.read<BigPictureStateProvider>().updateTickerProportion(
                  oldTicker: widget.ticker,
                  newSymbol: combinedSymbol,
                );

            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
