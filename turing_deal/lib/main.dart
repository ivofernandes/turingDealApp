import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/data/state/AppStateProvider.dart';
import 'package:turing_deal/screen/bigPictureScreen.dart';

void main() {
  runApp(TuringDealApp());
}

class TuringDealApp extends StatelessWidget {

  Widget rootScreen(BuildContext context, AppStateProvider appState){
    return MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        title: "TuringDeal",
        home: Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text('Turing deal'),
            ),
            body: Center(
                child: BigPictureScreen(appState))
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AppStateProvider(context),
        child: Consumer<AppStateProvider>(
            builder: (context, appState, child) {
              appState.loadData();
              return rootScreen(context, appState);
            })
    );
  }
}
