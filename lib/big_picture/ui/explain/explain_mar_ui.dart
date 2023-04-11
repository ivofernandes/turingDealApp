import 'package:flutter/material.dart';
import 'package:td_ui/td_ui.dart';

class ExplainMAR extends StatelessWidget {
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
                'MAR ratio',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'A MAR ratio is a measurement of returns adjusted for risk that can be used to compare the performance of different assets or strategies',
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('The MAR forumla is: MAR ='),
              const Text('CAGR / Max drawdown'),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Theme.of(context).textTheme.bodyText1!.color,
                child: Text('More about MAR',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.background)),
                onPressed: () {
                  Web.launchLink(context, 'https://www.investopedia.com/terms/m/mar-ratio.asp');
                },
              )
            ],
          ),
        ),
      );
}
