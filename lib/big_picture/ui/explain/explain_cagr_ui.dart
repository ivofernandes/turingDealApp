import 'package:flutter/material.dart';
import 'package:td_ui/td_ui.dart';

class ExplainCagr extends StatelessWidget {
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
                'Compound Annual Growth Rate – CAGR',
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'CAGR is the annualized percentage of return of an investment',
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('The CAGR forumla is: CAGR ='),
              const Text('(Starting value / Ending value) ^ (1 / number of years) - 1'),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  child: Text('More about CAGR',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.surface)),
                  onPressed: () {
                    Web.launchLink(context, 'https://www.investopedia.com/terms/c/cagr.asp');
                  })
            ],
          ),
        ),
      );
}
