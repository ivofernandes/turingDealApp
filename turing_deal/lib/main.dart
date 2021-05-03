import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/components/shared/appTheme.dart';
import 'package:turing_deal/data/state/AppStateProvider.dart';
import 'package:turing_deal/screen/rootScreen.dart';

void main() {
  runApp(TuringDealApp());
}

class TuringDealApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AppStateProvider(context),
        child: Consumer<AppStateProvider>(
            builder: (context, appState, child) {
              appState.loadData();
              return MaterialApp(
                  theme: AppTheme.darkTheme(),
                  debugShowCheckedModeBanner: false,
                  title: "TuringDeal",
                  home: RootScreen(appState)
              );
            })
    );
  }
}
