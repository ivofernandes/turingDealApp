import 'package:flutter/material.dart';
import 'package:turing_deal/shared/ui/Web.dart';
import 'package:turing_deal/shared/environment.dart';

class MenuComponent extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('The objective of this project is to help people to make decisions based on past measurable data instead of pseudo-science beliefs that fill the stock market, specially in this bubble environment.'),
          ),

          SizedBox(height: 10,),

          MaterialButton(
            color: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 10,
            child: Text('Contribute on github'),
              onPressed: () => Web.launchLink(context, Environment.GITHUB_URL))
        ],
      ),
    );
  }
}