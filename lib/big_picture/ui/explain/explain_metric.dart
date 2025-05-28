import 'package:flutter/material.dart';
import 'package:td_ui/td_ui.dart';

class ExplainMetric extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final List<String>? formula;
  final String linkLabel;
  final String linkUrl;
  final Color accentColor;

  const ExplainMetric({
    required this.title,
    required this.icon,
    required this.description,
    this.formula,
    required this.linkLabel,
    required this.linkUrl,
    required this.accentColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 40, color: accentColor),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                if (formula != null && formula!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  ...formula!.map((line) => Text(line, textAlign: TextAlign.center)).toList(),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () => Web.launchLink(context, linkUrl),
                  child: Text(linkLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExplainCagr extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ExplainMetric(
        title: 'Compound Annual Growth Rate – CAGR',
        icon: Icons.trending_up,
        description: 'CAGR is the annualized percentage of return of an investment.',
        formula: [
          'The CAGR formula is:',
          '(Ending value / Starting value) ^ (1 / number of years) - 1',
        ],
        linkLabel: 'More about CAGR',
        linkUrl: 'https://www.investopedia.com/terms/c/cagr.asp',
        accentColor: Theme.of(context).colorScheme.primary,
      );
}

class ExplainDrawdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ExplainMetric(
        title: 'Maximum Drawdown',
        icon: Icons.trending_down,
        description: 'The Max Drawdown is the biggest fall in the value of a portfolio following a strategy.',
        linkLabel: 'More about Drawdown',
        linkUrl: 'https://www.investopedia.com/terms/m/maximum-drawdown-mdd.asp',
        accentColor: Theme.of(context).colorScheme.error,
      );
}

class ExplainMAR extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ExplainMetric(
        title: 'MAR Ratio',
        icon: Icons.balance,
        description: 'The MAR ratio is a risk-adjusted performance metric used to compare investment strategies.',
        formula: [
          'The MAR formula is:',
          'CAGR / Max drawdown',
        ],
        linkLabel: 'More about MAR',
        linkUrl: 'https://www.investopedia.com/terms/m/mar-ratio.asp',
        accentColor: Theme.of(context).colorScheme.primary,
      );
}
