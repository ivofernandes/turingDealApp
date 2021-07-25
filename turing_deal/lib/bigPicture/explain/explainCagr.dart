import 'package:flutter/material.dart';
import 'package:turing_deal/shared/components/Web.dart';

class ExplainCagr extends StatelessWidget {
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
              'Compound Annual Growth Rate – CAGR',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'CAGR is the annualized percentage of return of an investment',
            ),
            SizedBox(
              height: 20,
            ),
            Text('The CAGR forumla is: CAGR ='),
            Text('(Starting value / Ending value) ^ (1 / number of years) - 1'),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
                color: Theme.of(context).textTheme.bodyText1!.color,
                child: Text('More about CAGR',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Theme.of(context).backgroundColor)),
                onPressed: () {
                  Web.openView(
                      context, 'https://www.investopedia.com/terms/c/cagr.asp');
                })
          ],
        ),
      ),
    );
  }
}
