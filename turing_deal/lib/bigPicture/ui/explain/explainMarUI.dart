import 'package:flutter/material.dart';
import 'package:turing_deal/shared/ui/Web.dart';

class ExplainMAR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'MAR ratio',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'A MAR ratio is a measurement of returns adjusted for risk that can be used to compare the performance of different assets or strategies',
            ),
            SizedBox(
              height: 20,
            ),
            Text('The MAR forumla is: MAR ='),
            Text('CAGR / Max drawdown'),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
                color: Theme.of(context).textTheme.bodyText1!.color,
                child: Text('More about MAR',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Theme.of(context).backgroundColor)),
                onPressed: () {
                  Web.openView(context,
                      'https://www.investopedia.com/terms/m/mar-ratio.asp');
                })
          ],
        ),
      ),
    );
  }
}
