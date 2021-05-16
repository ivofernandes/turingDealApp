import 'package:flutter/material.dart';
import 'package:turing_deal/components/shared/Web.dart';

class ExplainDrawdown extends StatelessWidget {
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
              'Maximum Drawdown',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'The Max Drawdown is the biggest fall in the value of a portfolio following a strategy',
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
                color: Theme.of(context).textTheme.bodyText1.color,
                child: Text('More about Drawdown',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Theme.of(context).backgroundColor)),
                onPressed: () {
                  Web.openView(context,
                      'https://www.investopedia.com/terms/m/maximum-drawdown-mdd.asp');
                })
          ],
        ),
      ),
    );
  }
}
