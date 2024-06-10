import 'package:flutter/material.dart';
import 'package:td_ui/td_ui.dart';

class ExplainDrawdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Maximum Drawdown',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'The Max Drawdown is the biggest fall in the value of a portfolio following a strategy',
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  child: Text('More about Drawdown',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.surface)),
                  onPressed: () {
                    Web.launchLink(context, 'https://www.investopedia.com/terms/m/maximum-drawdown-mdd.asp');
                  })
            ],
          ),
        ),
      );
}
