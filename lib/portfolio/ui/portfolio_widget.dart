import 'package:flutter/material.dart';

class PortfolioWidget extends StatelessWidget {
  final Map<String, double> pricesOfSymbols;

  const PortfolioWidget({
    required this.pricesOfSymbols,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text('prices = ${pricesOfSymbols.length}');
  }
}
